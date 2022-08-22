return require("telescope").register_extension {
  exports = {
    alternate_file = require('telescope-alternate.telescope').alternate
  }
}
