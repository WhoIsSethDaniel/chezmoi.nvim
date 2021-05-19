# chezmoi.nvim

[chezmoi](https://github.com/twpayne/chezmoi) integration with NeoVim.

(currently very primitive)

## Installation

Install this plugin like any other plugin. Make certain you have [chezmoi](https://github.com/twpayne/chezmoi) 
installed.

## Configuration

Somewhere in your configuration you will need:
```
lua <<EOF
require"chezmoi".setup()
EOF
```
You can pass configuration to setup().
```
lua <<EOF
require"chezmoi".setup({
  exec = "chezmoi.new",
  auto_add = true  -- the default is true
})
EOF
```
Options:
* exec: default 'chezmoi'. Only set 'exec' if you have installed chezmoi under a name other than 'chezmoi'. The given name must be in your path and executable.
* auto_add: default 'true'. Set to 'false' if you do not want changes to chezmoi managed files to be auto-added to the
  source state.

## Usage

Whenever you save a file that is managed by chezmoi it will be 'add'ed to the chezmoi
source state. This allows you to edit files as you normally would without thinking about 
using 'chezmoi edit'. 

### Commands

There are two commands that are defined:
* :ChezmoiAdd - this will add the current file to the chezmoi source state
* :ChezmoiRemove - this will remove the current file from the chezmoi source state (e.g. chezmoi forget ...)

## Status

There is very basic statusline integration. I use lualine and I do the following in my lualine 
config:
```
function chezmoi() return require 'chezmoi'.status() end
...
require('lualine').setup{
    ...
    sections = {
        ...
        lualine_c = { ... {chezmoi} ... }
        ...
    }
}
```
When you edit a file you will see a [CM] displayed when you are editing a file managed by chezmoi.
