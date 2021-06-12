# Description

[chezmoi](https://github.com/twpayne/chezmoi) integration with Neovim. Edit files, as normal, with Neovim
and have changes automatically placed in the Chezmoi source state. Also add and remove files from Chezmoi
source state from within Neovim.

## Compatibility
Neovim >= 0.5.0

## Installation
Install using your favorite plugin manager. Make certain you have [chezmoi](https://github.com/twpayne/chezmoi) 
installed.

If you use vim-plug:
```vim
Plug 'WhoIsSethDaniel/chezmoi.nvim'
```
Or if you use Vim 8 style packages:
```
cd <plugin dir>
git clone https://github.com/WhoIsSethDaniel/chezmoi.nvim
```

## Configuration

Somewhere in your configuration you will need:
```lua
require"chezmoi".setup()
```
You can pass configuration to setup().
```lua
require"chezmoi".setup({
  exec = "chezmoi.new",
  auto_add = true,  -- the default is true
  add_options = '--empty'
})
```
If you are using Vimscript for configuration:
```vim
lua <<EOF
require"chezmoi".setup()
EOF
```
Options:
* `exec`: default 'chezmoi'. Only set 'exec' if you have installed chezmoi under a name other than 'chezmoi'. The given name must be in your path and executable.
* `auto_add`: default 'true'. Set to 'false' if you do not want changes to chezmoi managed files to be auto-added to the source state.
* `add_options`: default '--empty'. A string of options for 'chezmoi add'. By default this is '--empty' which means empty files will be added. If you set this option and wish for empty files to be added you will need to add '--empty' since setting this option removes the default. This is also the default if you use :ChezmoiAdd.

## Usage

Whenever you save a file that is managed by chezmoi it will be 'add'ed to the chezmoi
source state. This allows you to edit files as you normally would without thinking about 
using 'chezmoi edit'. 

### Commands

There are two commands that are defined:
* `:ChezmoiAdd`: this will add the current file to the chezmoi source state. Pass options the same way you would pass them to chezmoi. e.g.
```vim
:ChezmoiAdd --empty --exact
```
This will add the current file and will pass the --exact and --empty options to chezmoi. Default options may be set using the add_options configuration variable.
* `:ChezmoiForget`: this will remove the current file from the chezmoi source state (e.g. chezmoi forget ...)

## Status Line

There is very basic statusline integration. I use lualine and I do the following in my lualine 
config:
```lua
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
