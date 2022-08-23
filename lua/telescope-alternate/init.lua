local M = {}

function M.setup(opts)
  if not opts.mappings then
    vim.notify("Please inform the mappings on your telescope-alternate setup")
  end

  local mappings = opts.mappings or {}
  local enabled_presets = opts.presets or {}
  local presets = require('telescope-alternate.presets')

  for i = 1, #enabled_presets, 1 do
    for k,v in pairs(presets[enabled_presets[i]]) do mappings[k] = v end
  end

  vim.g.telescope_alternate_transformers = opts.transformers
  vim.g.telescope_alternate_mappings = mappings
end

return M
