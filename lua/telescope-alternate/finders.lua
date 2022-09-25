local M = {}

local utils = require('telescope-alternate.utils')

local functions = function()
  local user_functions = vim.g.telescope_alternate_transformers or {}
  local funcs = require('telescope-alternate.functions')

  for k,v in pairs(user_functions) do funcs[k] = v end

  return funcs
end

M.action_types = { "switch", "create", "create_on_dir", "create_using_regexp" }

function M.in_array(arr, element)
  for i = 1, #arr, 1 do
    if arr[i].path == element.path and arr[i].type == element.type then
      return true
    end
  end

  return false
end

function M.parse_available_matches(config)
  local actions = {}
  local targets_with_matches = {}

  ---@diagnostic disable-next-line: unused-local
  for __, value in pairs(config) do
    local parseds = M.add_matches_to_targets(value)

    for j = 1, #parseds, 1 do
      table.insert(targets_with_matches, parseds[j])
    end
  end

  for i = 1, #targets_with_matches do
    local target = targets_with_matches[i]
    local full_path = target[1]
    local label = target[2]
    local ignoreCreate = target[3]

    if utils.isfile(full_path) ~= 0 then
      table.insert(actions, { path = full_path, type = M.action_types[1], label = label })
    elseif utils.isdir(full_path) ~= 0 then
      local files = utils.files_in_path(full_path)

      for z = 1, #files, 1 do
        if utils.isfile(files[z]) ~= 0 then
          table.insert(actions, { path = files[z], type = M.action_types[1], label = label })
        end
      end

      if not ignoreCreate then
        table.insert(actions, { path = full_path, type = M.action_types[3], prefix = "NEW ", label = label })
      end
    else
      if #{ string.match(full_path, "%*%*/%*"), string.match(full_path, "%*") } > 0 then
        local results = utils.capture(full_path)

        for r = 1, #results, 1 do
          if utils.isfile(results[r]) then
            local file_label

            if label == full_path then
              file_label = label
            else
              local differences = table.concat(utils.path_difference(full_path, results[r]), ' ')

              if differences ~= '' then
                file_label = label .. ': ' .. differences
              else
                file_label = label
              end
            end

            table.insert(actions, { path = results[r], type = M.action_types[1], label = file_label })
          end
        end

        if not ignoreCreate then
          table.insert(actions, { path = full_path, type = M.action_types[4], prefix = "NEW ", label = label })
        end
      elseif not ignoreCreate then
        local last_char = string.sub(full_path, -1, -1)

        if last_char == '/' then
          table.insert(actions, { path = full_path, type = M.action_types[3], prefix = "NEW AT ", label = label })
        else
          table.insert(actions, { path = full_path, type = M.action_types[2], prefix = "NEW ", label = label })
        end
      end
    end
  end

  local fixed_actions = {}

  for i = 1, #actions, 1 do
    if not M.in_array(fixed_actions, actions[i]) then
      table.insert(fixed_actions, actions[i])
    end
  end

  return fixed_actions
end

function M.run_functions_on_matches(match, w)
  local fns = w:match("%d:(.+)]")

  local res = match
  local regxEverythingExceptComma = '([^,]+)'
  for fn in string.gmatch(fns, regxEverythingExceptComma) do
    res = functions()[fn](res)
  end

  return res
end

function M.add_matches_to_targets(config)
  local parsed_targets = {}
  local targets = config.targets
  local matches = config.matches

  for t = 1, #targets do
    local real_target = targets[t]
    local target
    local name = real_target
    local ignoreCreate = false

    if type(real_target) == "string" then
      target = real_target
    else
      target = real_target[1]
      name = real_target[2]
      ignoreCreate = real_target[3] or false
    end

    for i = 1, #matches do
      local with_function_regex = "(%[" .. i .. ":[,a-zA-Z_1-9]*])"
      local without_function_regex = "(%[" .. i .. "])"

      target = target:gsub(with_function_regex, function(w) return M.run_functions_on_matches(matches[i], w) end)
      target = target:gsub(without_function_regex, matches[i])
    end

    table.insert(parsed_targets, { target, name, ignoreCreate })
  end

  return parsed_targets
end

function M.go_to_selection(selection)
  local type = selection.type

  if type == M.action_types[1] then
    vim.cmd("e " .. selection.path)
  elseif type == M.action_types[2] then
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    vim.cmd("e " .. selection.path)
    vim.notify(selection.path .. ' created!')
  elseif type == M.action_types[3] then
    local new_file_name = vim.fn.input('name of the file to create at ' .. selection.path)

    if #new_file_name > 0 then
      local file_name = vim.fn.fnamemodify(selection.path, ":h")

      if utils.isdir(selection.path) == 0 then
        vim.fn.mkdir(file_name, "p")
      end

      vim.cmd("e " .. file_name .. "/" .. new_file_name)
      vim.notify(file_name .. ' created!')
    end
  elseif type == M.action_types[4] then
    local completed = false
    local answer = ''
    local path

    while not completed do
      path = selection.path

      while string.match(path, "%*%*/%*") or string.match(path, "%*") do
        local input

        if string.match(path, "%*%*/%*") then
          input = "**/*"
        else
          input = "*"
        end

        local replace_for = vim.fn.input("Change first ocurrence of " .. input .. " in " .. path .. ' (Can be leaved blank): ')

        local fixed_input = string.gsub(input, "%*", "%%*")

        path = string.gsub(path, fixed_input, replace_for, 1)
      end

      answer = vim.fn.input("Path " .. path .. " is correct? y/n/c: ")

      if answer == "y" or answer == "c" then
        completed = true
      end
    end

    if answer == "y" then
      if not utils.isfile(path) then
        vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
      end

      vim.cmd("e " .. path)
    end
  end
end

function M.find_alternatve_files()
  local current_file_name = utils.current_file_name()

  local matched_targets = {}
  local matched_strings = {}
  local config = vim.g.telescope_alternate_mappings or {}

  for i = 1, #config, 1 do
    matched_strings = { string.match(current_file_name, utils.normalize_path(config[i][1])) }

    if #matched_strings > 0 then
      table.insert(matched_targets, { targets = config[i][2], matches = matched_strings })
    end
  end

  if #matched_targets then
    local parsed = M.parse_available_matches(matched_targets)

    table.sort(parsed, function(a, b)
      return a.prefix == nil and b.prefix == 'NEW '
    end)

    return parsed
  end

  return false
end

return M
