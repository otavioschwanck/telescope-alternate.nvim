# telescope-alternate

Alternate between common files using pre-defined regexp.  Just map the patterns and starting navigating between files that are related.

Telescope alternate also can create files when it is missing (including files with regexp at destination)

![demo](demo.gif)

# Installation

## Packer

```lua
use { "otavioschwanck/telescope-alternate" }
```

## Setup Example

```lua
require('telescope-alternate').setup({
    mappings = {
      { 'app/services/(.*)_services/(.*).rb', { -- alternate from services to contracts / models
        { 'app/contracts/[1]_contracts/[2].rb', 'Contract' }, -- Adding label to switch
        { 'app/models/**/*[1].rb', 'Model', true }, -- Ignore create entry (with true)
      } },
      { 'app/contracts/(.*)_contracts/(.*).rb', { { 'app/services/[1]_services/[2].rb', 'Service' } } }, -- from contracts to services
      -- Search anything on helper folder that contains pluralize version of model.
      --Example: app/models/user.rb -> app/helpers/foo/bar/my_users_helper.rb
      { 'app/models/(.*).rb', { { 'db/helpers/**/*[1:pluralize]*.rb', 'Helper' } } },
      { 'app/**/*.rb', { { 'spec/[1].rb', 'Test' } } }, -- Alternate between file and test
    },
    presets = { 'rails' }, -- Telescope pre-defined mapping presets
    transformers = { -- custom transformers
      change_to_uppercase = function(w) return my_uppercase_method(w) end
    }
  })

-- On your telescope:
require('telescope').load_extension('telescope-alternate')
```

To run alternate, just type:
:Telescope telescope-alternate alternate

# How to use?

Inside mappings, the syntax is:

```lua
{ 'current-file', { { 'destination', 'label', ignoreCreate (true or false) } } }
```

Each `current-file` can have multiple destinations.

On `current-file`, each (.*) is a match.

On `destination`, each [1], [2], [3] is the text matched text of `current-file` (by order)

You can run some transformers on the destination, using :function-name, example: [1:singularize]

The available functions are:

| Function Name  | Description           |
|----------------|-----------------------|
| camel_to_kebap | userName -> user-name |
| kebap_to_camel | user-name -> userName |
| pluralize      | userName -> userNames |
| singularize    | userNames -> userName |


Example:

```lua
{ 'app/models/(.*).rb', {
  { 'db/helpers/**/*[1]*.rb', 'Helper' } },
  { 'app/controllers/**/*[1:pluralize]_controller.rb', 'Controller' } },
},
```
