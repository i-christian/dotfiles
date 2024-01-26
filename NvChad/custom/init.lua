vim.cmd([[
  augroup MyAutoCmds
    autocmd!
    autocmd FileType c
      \ setlocal shiftwidth=4 |
      \ setlocal tabstop=4 |
      \ setlocal textwidth=79 |
      \ setlocal noexpandtab
    autocmd BufWritePre * :%s/\s\+$//e
  augroup END
]])

