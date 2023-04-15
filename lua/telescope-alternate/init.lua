local M = {}

M.default_mappings = {
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

M.mappings = {}

function M.setup(opts)
  if not opts.mappings and not opts.presets then
    return
  end

  local mappings = opts.mappings or {}
  local enabled_presets = opts.presets or {}
  local presets = require('telescope-alternate.presets')

  for i = 1, #enabled_presets, 1 do
    for _, v in pairs(presets[enabled_presets[i]]) do
      table.insert(mappings, v)
    end
  end

  vim.g.telescope_alternate_transformers = opts.transformers
  vim.g.telescope_alternate_mappings = mappings
  vim.g.telescope_open_only_one_with = opts.open_only_one_with or 'current_pane'

  M.mappings = opts.telescope_mappings or M.default_mappings
end

return M
