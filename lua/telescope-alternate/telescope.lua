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

  if #results == 1 and results[1].type == "switch" then
    alternate.go_to_selection(results[1])
  elseif #results > 0 then
    local biggest = 0

    for i = 1, #results do
      local size = #(results[i].prefix or {}) + #results[i].label

      if size > biggest then
        biggest = size
      end
    end

    for i = 1, #results do
      local spaces = ""

      local current_display = (results[i].prefix or "") .. results[i].label

      for _ = 1, biggest - #current_display do
        spaces = spaces .. " "
      end

      results[i].display = current_display .. spaces .. " | " .. results[i].path
    end

    pickers.new(opts, {
      prompt_title = "Telescope Find Alternate",
      finder = finders.new_table {
        results = results,
        entry_maker = function(entry)
          return { value = entry.path, display = entry.display, ordinal = entry.display, entry = entry }
        end
      },
      sorter = conf.generic_sorter(opts),
      previewer = conf.file_previewer({}),
      attach_mappings = function(prompt_bufnr, _)
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
