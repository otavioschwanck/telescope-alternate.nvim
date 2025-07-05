-- telescope-alternate.lua
-- Main plugin file that sets up the plugin when loaded

-- Only load once
if vim.g.loaded_telescope_alternate then
  return
end
vim.g.loaded_telescope_alternate = true

-- Create user command for telescope-alternate
vim.api.nvim_create_user_command('TelescopeAlternate', function(opts)
  require('telescope-alternate').alternate_file(opts.args)
end, {
  nargs = '?',
  desc = 'Find alternate files using telescope-alternate'
})

-- Auto-load telescope extension if telescope is available
vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopeLoaded',
  callback = function()
    local ok, telescope = pcall(require, 'telescope')
    if ok then
      telescope.load_extension('telescope-alternate')
    end
  end,
})

-- If telescope is already loaded, load the extension immediately
if pcall(require, 'telescope') then
  require('telescope').load_extension('telescope-alternate')
end