if exists("g:chezmoi_loaded_install")
  finish
endif
let g:chezmoi_loaded_install = 1

let s:cpo_save = &cpo
set cpo&vim

augroup chezmoi_autosave
    autocmd! 
    autocmd BufWritePost * lua require'chezmoi'.save('%')
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
