local M = {}

local utils = require('telescope-alternate.utils')

local functions = function()
  local user_functions = vim.g.telescope_alternate_transformers or {}
  local funcs = require('telescope-alternate.functions')

  for k,v in pairs(user_functions) do funcs[k] = v end

  return funcs
end

M.action_types = { "switch", "create", "create_on_dir" }

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
    local t = targets_with_matches[i]

    if utils.isfile(t) ~= 0 then
      table.insert(actions, { path = t, type = M.action_types[1] })
    elseif utils.isdir(t) ~= 0 then
      local files = utils.files_in_path(t)

      for z = 1, #files, 1 do
        if utils.isfile(files[z]) ~= 0 then
          table.insert(actions, { path = files[z], type = M.action_types[1] })
        end
      end

      table.insert(actions, { path = t, type = M.action_types[3], prefix = "[new at dir] " })
    else
      local last_char = string.sub(t, -1, -1)

      if last_char == '/' then
        table.insert(actions, { path = t, type = M.action_types[3], prefix = "[new at dir] " })
      else
        table.insert(actions, { path = t, type = M.action_types[2], prefix = "[new] " })
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
  local fn = w:match("%d:(.+)]")

  return functions()[fn](match)
end

function M.add_matches_to_targets(config)
  local parsed_targets = {}
  local targets = config.targets
  local matches = config.matches

  for t = 1, #targets do
    local target = targets[t]

    for i = 1, #matches do
      local with_function_regex = "(%[" .. i .. ":[a-zA-Z_1-9]*])"
      local without_function_regex = "(%[" .. i .. "])"

      target = target:gsub(with_function_regex, function(w) return M.run_functions_on_matches(matches[i], w) end)
      target = target:gsub(without_function_regex, matches[i])
    end

    table.insert(parsed_targets, target)
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
    return parsed
  end

  return false
end

return M
