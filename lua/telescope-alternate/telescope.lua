local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local alternate = require "telescope-alternate.finders"

local M = {}

local function call_with(command, prompt_bufnr)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry().entry

  alternate.go_to_selection(selection, command)
end

function M.alternate(alt_opts)
  local opts = alt_opts or {}

  local results = alternate.find_alternatve_files() or {}

  if #results == 1 and results[1].type == "switch" then
    alternate.go_to_selection(results[1], vim.g.telescope_open_only_one_with)
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
      attach_mappings = function(prompt_bufnr, map)
        local mappings = require("telescope-alternate").mappings
        local default_mappings = require("telescope-alternate").default_mappings

        map("i", mappings.i.open_current or default_mappings.i.open_current, function()
          call_with('current_pane', prompt_bufnr)
        end)

        map("n", mappings.n.open_current or default_mappings.n.open_current, function()
          call_with('current_pane', prompt_bufnr)
        end)

        map("i", mappings.i.open_vertical or default_mappings.i.open_vertical, function()
          call_with('vertical_split', prompt_bufnr)
        end)

        map("n", mappings.n.open_vertical or default_mappings.n.open_vertical, function()
          call_with('vertical_split', prompt_bufnr)
        end)

        map("i", mappings.i.open_horizontal or default_mappings.i.open_horizontal, function()
          call_with('horizontal_split', prompt_bufnr)
        end)

        map("n", mappings.n.open_horizontal or default_mappings.n.open_horizontal, function()
          call_with('horizontal_split', prompt_bufnr)
        end)

        map("i", mappings.i.open_tab or default_mappings.i.open_tab, function()
          call_with('tab', prompt_bufnr)
        end)

        map("n", mappings.n.open_tab or default_mappings.n.open_tab, function()
          call_with('tab', prompt_bufnr)
        end)

        return true
      end,
    }):find()
  else
    vim.notify("This file doesn't matches any alternate")
  end
end

return M
