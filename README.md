# chezmoi.nvim

[chezmoi](https://github.com/twpayne/chezmoi) integration with NeoVim.

(currently very primitive)

## Usage

Install this plugin like any other plugin. Make certain you have chezmoi installed.

Whenever you save a file that is managed by chezmoi it will be 'add'ed to the chezmoi
source state. This allows you to edit files as you normally would without thinking about 
using 'chezmoi edit'. 

There is very basic statusline integration. I use lualine and I do the following in my lualine 
config:
```
function chezmoi() return require 'chezmoi'.chezmoi_status() end
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
