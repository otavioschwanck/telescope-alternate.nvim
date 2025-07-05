# telescope-alternate

Alternate between common files using pre-defined regexp. Just map the patterns and start navigating between files that are related.

Telescope alternate can create files when they are missing (including files with regexp at destination).

**Now supports both Telescope and fzf-lua!**

![demo](demo.gif)

# Installation

## Using your favorite plugin manager

**Packer:**
```lua
use { "otavioschwanck/telescope-alternate" }
```

**Lazy.nvim:**
```lua
{
  "otavioschwanck/telescope-alternate",
  dependencies = { "nvim-telescope/telescope.nvim" }, -- or { "ibhagwan/fzf-lua" }
}
```

**vim-plug:**
```vim
Plug 'otavioschwanck/telescope-alternate'
```

# Configuration

## Basic Setup

```lua
-- Configuration using vim.g (recommended approach)
vim.g.telescope_alternate = {
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
  presets = { 'rails', 'rspec', 'nestjs', 'angular' }, -- Pre-defined mapping presets
  picker = 'telescope', -- or 'fzf-lua'
  open_only_one_with = 'current_pane', -- when just have only possible file, open it with.  Can also be horizontal_split and vertical_split
  transformers = { -- custom transformers
    change_to_uppercase = function(w) return my_uppercase_method(w) end
  },
  telescope_mappings = { -- Change the telescope mappings
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

-- Alternative setup method (legacy, still supported)
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
    presets = { 'rails', 'rspec', 'nestjs', 'angular' }, -- Pre-defined mapping presets
    picker = 'telescope', -- or 'fzf-lua'
    open_only_one_with = 'current_pane', -- when just have only possible file, open it with.  Can also be horizontal_split and vertical_split
    transformers = { -- custom transformers
      change_to_uppercase = function(w) return my_uppercase_method(w) end
    },
    telescope_mappings = { -- Change the telescope mappings
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
  })

## Alternative Configuration Methods

### Using Telescope Setup (Legacy)
```lua
require('telescope').setup{
  extensions = {
    ["telescope-alternate"] = {
      mappings = {
        -- your mappings here
      },
      presets = { 'rails', 'nestjs' },
      picker = 'telescope' -- or 'fzf-lua'
    },
  },
}
```

### Verbose Mapping Syntax
```lua
mappings = {
  { pattern = 'app/services/(.*)_services/(.*).rb', targets = {
      { template =  'app/contracts/[1]_contracts/[2].rb', label = 'Contract', enable_new = true } -- enable_new can be a function too.
    }
  },
  { pattern = 'app/contracts/(.*)_contracts/(.*).rb', targets = {
      { template =  'app/services/[1]_services/[2].rb', label = 'Service', enable_new = true }
    }
  },
}
```

# Usage

## Using with Telescope

The plugin automatically loads the telescope extension when available. You can use:

```vim
:Telescope telescope-alternate alternate_file
```

Or use the provided command:
```vim
:TelescopeAlternate
```

## Using with fzf-lua

Configure with fzf-lua picker:
```lua
vim.g.telescope_alternate = {
  picker = 'fzf-lua',
  mappings = {
    -- your mappings here
  }
}
```

Then run:
```lua
:lua require('telescope-alternate').alternate_file()
```

## Key Mappings

You can create convenient key mappings:

```lua
-- Using the provided command (recommended)
vim.keymap.set('n', '<leader>ta', ':TelescopeAlternate<CR>', { desc = 'Alternate file' })

-- Or using telescope directly
vim.keymap.set('n', '<leader>ta', ':Telescope telescope-alternate alternate_file<CR>', { desc = 'Alternate file' })

-- Or using lua function directly
vim.keymap.set('n', '<leader>ta', function() require('telescope-alternate').alternate_file() end, { desc = 'Alternate file' })
```

# How Mappings Work

## Basic Syntax

```lua
{ 'current-file-pattern', { { 'destination-pattern', 'label', ignoreCreate (true or false) } } }
```

- Each `current-file-pattern` can have multiple destinations
- Each `(.*)` in the current file pattern is a capture group
- Each `[1]`, `[2]`, `[3]` in the destination pattern refers to the corresponding capture group
- The third parameter controls whether to allow creating new files (optional, defaults to false)

## Pattern Matching

When you're editing a file, the plugin will:
1. Match the current file path against all patterns
2. If a pattern matches, show all possible alternate files
3. Allow you to switch to existing files or create new ones

## Transformers

You can apply transformers to captured groups using the syntax: `[1:function_name]` or `[1:function1,function2]`

### Available Transformers

| Function Name  | Description           | Example                    |
|----------------|-----------------------|----------------------------|
| camel_to_kebap | userName -> user-name | `[1:camel_to_kebap]`      |
| kebap_to_camel | user-name -> userName | `[1:kebap_to_camel]`      |
| pluralize      | userName -> userNames | `[1:pluralize]`           |
| singularize    | userNames -> userName | `[1:singularize]`         |

### Custom Transformers

You can define custom transformers:

```lua
require('telescope-alternate').setup({
  transformers = {
    my_custom_transformer = function(text)
      return text:upper()
    end
  }
})
```

## Example Mappings

```lua
{
  'app/models/(.*).rb', {
    { 'db/helpers/**/*[1]*.rb', 'Helper' },
    { 'app/controllers/**/*[1:pluralize]_controller.rb', 'Controller' },
    { 'spec/models/[1]_spec.rb', 'Test' }
  }
}
```

This mapping will:
- Match files like `app/models/user.rb`
- Offer to switch to `db/helpers/**/user*.rb` files
- Offer to switch to `app/controllers/**/users_controller.rb` 
- Offer to switch to `spec/models/user_spec.rb`

# Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `picker` | string | `'telescope'` | Choose between `'telescope'` or `'fzf-lua'` |
| `mappings` | table | `{}` | File pattern mappings |
| `presets` | table | `{}` | Pre-defined mapping presets |
| `open_only_one_with` | string | `'current_pane'` | How to open file when only one match. Options: `'current_pane'`, `'horizontal_split'`, `'vertical_split'`, `'tab'` |
| `transformers` | table | `{}` | Custom transformer functions |
| `telescope_mappings` | table | `{}` | Custom telescope key mappings |

# Presets

The plugin comes with several presets for common project structures:

- `'rails'` - Ruby on Rails project mappings
- `'rspec'` - RSpec test mappings  
- `'nestjs'` - NestJS project mappings
- `'angular'` - Angular project mappings

Example:
```lua
require('telescope-alternate').setup({
  presets = { 'rails', 'rspec' }
})
```
