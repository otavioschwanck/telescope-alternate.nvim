local M = {}

function M.alternate(alt_opts)
  local opts = alt_opts or {}
  
  -- Check if fzf-lua is available
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("fzf-lua is not installed or not available", vim.log.levels.ERROR)
    return
  end
  
  local alternate = require "telescope-alternate.finders"
  local results = alternate.find_alternatve_files() or {}
  
  if #results == 0 then
    vim.notify("This file doesn't match any alternate")
    return
  end
  
  if #results == 1 and results[1].type == "switch" then
    alternate.go_to_selection(results[1], vim.g.telescope_open_only_one_with)
    return
  end
  
  -- Prepare items with file paths for preview
  local file_list = {}
  for i = 1, #results do
    local prefix = results[i].prefix or ""
    local label = results[i].label or ""
    local path = results[i].path or ""
    
    -- Format: "filepath # display_text"
    if vim.fn.filereadable(path) == 1 then
      table.insert(file_list, path .. " # " .. prefix .. label)
    else
      -- For non-existing files, still add them but mark them
      table.insert(file_list, path .. " # " .. prefix .. label .. " (NEW)")
    end
  end
  
  -- Use fzf-lua's actual default preview command
  local config = require('fzf-lua.config')
  local files_config = config.globals.files or {}
  
  -- Get fzf-lua's default preview - let's see what they actually use
  local fzf_defaults = require('fzf-lua.defaults').defaults
  local default_preview = fzf_defaults.files and fzf_defaults.files.preview
  local preview_cmd = files_config.preview or default_preview or config.defaults.preview
  
  print("DEBUG: Using preview_cmd =", preview_cmd)
  
  -- If still no preview command found, create our own that should work
  if not preview_cmd then
    preview_cmd = [[sh -c 'if command -v bat >/dev/null 2>&1; then bat --style=numbers --color=always "{}"; elif command -v batcat >/dev/null 2>&1; then batcat --style=numbers --color=always "{}"; else cat -n "{}"; fi']]
  end
  
  -- Use fzf_exec with proper file preview
  fzf.fzf_exec(file_list, {
    prompt = "Find Alternate> ",
    fzf_opts = {
      ['--delimiter'] = ' # ',
      ['--with-nth'] = '2..',
      ['--preview'] = preview_cmd:gsub('{}', '{1}'),
      ['--preview-window'] = files_config.preview_window or 'right:50%'
    },
    actions = {
      ["default"] = function(selected, o)
        if selected and #selected > 0 then
          local selection = selected[1]
          -- Extract the file path (before " # ")
          local path = selection:match("^(.-)%s#")
          -- Find the corresponding result by path
          for i = 1, #results do
            if results[i].path == path then
              alternate.go_to_selection(results[i], 'current_pane')
              break
            end
          end
        end
      end,
      ["ctrl-v"] = function(selected, o)
        if selected and #selected > 0 then
          local selection = selected[1]
          local path = selection:match("^(.-)%s#")
          for i = 1, #results do
            if results[i].path == path then
              alternate.go_to_selection(results[i], 'vertical_split')
              break
            end
          end
        end
      end,
      ["ctrl-s"] = function(selected, o)
        if selected and #selected > 0 then
          local selection = selected[1]
          local path = selection:match("^(.-)%s#")
          for i = 1, #results do
            if results[i].path == path then
              alternate.go_to_selection(results[i], 'horizontal_split')
              break
            end
          end
        end
      end,
      ["ctrl-t"] = function(selected, o)
        if selected and #selected > 0 then
          local selection = selected[1]
          local path = selection:match("^(.-)%s#")
          for i = 1, #results do
            if results[i].path == path then
              alternate.go_to_selection(results[i], 'tab')
              break
            end
          end
        end
      end,
    }
  })
end

return M