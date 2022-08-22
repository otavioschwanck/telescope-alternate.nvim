local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local alternate = require "telescope-alternate.finders"

local M = {}

function M.alternate(alt_opts)
  local opts = alt_opts or {}

  local results = alternate.find_alternatve_files() or {}

  if #results == 1 then
    alternate.go_to_selection(results[1])
  elseif #results > 0 then
    pickers.new(opts, {
      prompt_title = "Telescope Find Alternate",
      finder = finders.new_table {
        results = results,
        entry_maker = function(entry)
          return { value = entry.path, display = (entry.prefix or "") .. entry.path, ordinal = (entry.prefix or "") .. entry.path, entry = entry }
        end
      },
      sorter = conf.generic_sorter(opts),
      previewer = conf.file_previewer({}),
      attach_mappings = function(prompt_bufnr, __)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry().entry

          alternate.go_to_selection(selection)
        end)
        return true
      end,
    }):find()
  else
    vim.notify("This file doesn't matches any alternate")
  end
end

return M
