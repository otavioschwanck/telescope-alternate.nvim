# telescope-alternate

Alternate in common files using pre-defined regexp.  Also, create missing files using those patterns.

# Installation

## Packer

use { "otavioschwanck/telescope-alternate" }

```lua
require('telescope-alternate').setup({
    mappings = {
      { "app/(.*).rb", { "spec/[1]_spec.rb" } }, -- alternate with test
      { "app/services/(.*)_services/(.*).rb", { "app/contracts/[1]_contracts/[2].rb", "spec/services/[1]_services/[2]_spec.rb" } }, -- alternate service <> contract
      { "app/contracts/(.*)_contracts/(.*).rb", { "app/services/[1]_services/[2].rb" } }, -- alternate contract <> service
      { "app/controllers/(.*)_controller.rb", { "app/views/[1]/", "app/models/[1:singularize].rb" } } -- go to folder / use transformer
    },
    presets = { 'rails' },
    transformers = { -- custom transformers
      change_to_uppercase = function(w) return my_uppercase_method(w) end
    }
  })
```
