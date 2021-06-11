# chezmoi.nvim

[chezmoi](https://github.com/twpayne/chezmoi) integration with NeoVim.

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
  auto_add = true,  -- the default is true
  add_options = '--empty'
})
EOF
```
Options:
* exec: default 'chezmoi'. Only set 'exec' if you have installed chezmoi under a name other than 'chezmoi'. The given name must be in your path and executable.
* auto_add: default 'true'. Set to 'false' if you do not want changes to chezmoi managed files to be auto-added to the
  source state.
* add_options: default '--empty'. A string of options for 'chezmoi add'. By default this is '--empty' which means empty
  files will be added. If you set this option and wish for empty files to be added you will need to add '--empty' since
  setting this option removes the default. This is also the default if you use :ChezmoiAdd.

## Usage

Whenever you save a file that is managed by chezmoi it will be 'add'ed to the chezmoi
source state. This allows you to edit files as you normally would without thinking about 
using 'chezmoi edit'. 

### Commands

There are two commands that are defined:
* :ChezmoiAdd - this will add the current file to the chezmoi source state. Pass options the same way you would pass
  them to chezmoi. e.g.
```
:ChezmoiAdd --empty --exact
```
  This will add the current file and will pass the --exact and --empty options to chezmoi. Default options may be set
  using the add_options configuration variable.
* :ChezmoiForget - this will remove the current file from the chezmoi source state (e.g. chezmoi forget ...)

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
