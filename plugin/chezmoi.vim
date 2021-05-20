if exists("g:chezmoi_loaded_install")
  finish
endif
let g:chezmoi_loaded_install = 1

let s:cpo_save = &cpo
set cpo&vim

command! -nargs=* ChezmoiAdd lua require'chezmoi'.cmdline_add('%', "<args>")
command! -nargs=0 ChezmoiRemove lua require'chezmoi'.remove('%')

let &cpo = s:cpo_save
unlet s:cpo_save
