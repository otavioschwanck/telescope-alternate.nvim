local M = {}

local function get_config()
  local config = vim.g.telescope_alternate or {}
  
  local default_config = {
    mappings = {},
    presets = {},
    picker = 'telescope',
    open_only_one_with = 'current_pane',
    transformers = {},
    telescope_mappings = {
      i = {
        open_current = '<CR>',
        open_horizontal = '<C-s>',
        open_vertical = '<C-v>',
        open_tab = '<C-t>',
      },
      n = {
        open_current = '<CR>',
        open_horizontal = '<C-s>',
        open_vertical = '<C-v>',
        open_tab = '<C-t>',
      }
    }
  }
  
  return vim.tbl_deep_extend('force', default_config, config)
end

local function initialize_mappings()
  local config = get_config()
  local mappings = vim.deepcopy(config.mappings or {})
  local enabled_presets = config.presets or {}
  
  if #enabled_presets > 0 then
    local presets = require('telescope-alternate.presets')
    for i = 1, #enabled_presets, 1 do
      for _, v in pairs(presets[enabled_presets[i]]) do
        table.insert(mappings, v)
      end
    end
  end
  
  return mappings
end

function M.alternate_file(opts)
  local config = get_config()
  local picker = config.picker
  
  if picker == 'fzf-lua' then
    require('telescope-alternate.fzf-lua').alternate(opts)
  else
    require('telescope-alternate.telescope').alternate(opts)
  end
end

function M.get_mappings()
  return initialize_mappings()
end

function M.get_config()
  return get_config()
end

function M.setup(opts)
  if opts then
    vim.g.telescope_alternate = opts
  end
end

return M
