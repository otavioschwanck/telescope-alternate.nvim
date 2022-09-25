return require("telescope").register_extension {
  setup = require('telescope-alternate').setup,
  exports = {
    alternate_file = require('telescope-alternate.telescope').alternate
  }
}
