local M = {}

function M.setup(opts)
  if not opts.mappings then
    vim.notify("Please inform the mappings on your telescope-alternate setup")
  end

  vim.g.telescope_alternate_mappings = opts.mappings or {}
end

M.setup({ mappings = {
  { "lua/(.+)/(.+).lua", {
    "lua/telescope/_extensions/telescope-alternate.lua",
    "lua/tests/[1:singularize]/[2:pluralize]/[2:singularize]_test/[2].lua",
    "lua/",
    "cachorro/",
    ".luarc.json"
  } }
} })

return M
