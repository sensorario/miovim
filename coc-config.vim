" ============================================================================
" Configurazioni COC (Conquer of Completion)
" Da aggiungere al .vimrc dopo l'installazione dei plugin
" ============================================================================

" Estensioni COC da installare automaticamente
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-prettier',
  \ 'coc-eslint',
  \ 'coc-emmet',
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-marketplace',
  \ 'coc-explorer',
  \ 'coc-git',
  \ 'coc-highlight',
  \ 'coc-yank',
  \ 'coc-lists',
  \ ]

" Completamento con Tab
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Conferma completamento con Enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Trigger completamento manuale
inoremap <silent><expr> <c-space> coc#refresh()

" Navigazione diagnostici
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Mostra documentazione
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Evidenzia symbol sotto cursore
autocmd CursorHold * silent call CocActionAsync('highlight')

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" Formattazione selezione o documento (come VS Code)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format)

" Prettier specifico (esattamente come Shift+Alt+F in VS Code)
nmap <M-S-f> :CocCommand prettier.formatFile<CR>
imap <M-S-f> <ESC>:CocCommand prettier.formatFile<CR>a
vmap <M-S-f> <Plug>(coc-format-selected)

" Format on save è gestito da coc-settings.json, non qui

augroup mygroup
  autocmd!
  " Setup formatexpr per tipi specifici
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Code actions
xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction)

" AutoFix del problema corrente
nmap <leader>qf  <Plug>(coc-fix-current)

" Mappa function e class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Usa CTRL-S per select ranges
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Comandi utili
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappature per lista COC
nnoremap <silent><nowait> <space>cd  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>ce  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>cc  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>co  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>cs  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>cj  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>ck  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>cp  :<C-u>CocListResume<CR>

" COC Explorer
nnoremap <space>e :CocCommand explorer<CR>

" Git con COC
nnoremap <silent> <space>cg  :<C-u>CocList --normal gstatus<CR>

" Snippets
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Prettier: comandi aggiuntivi come VS Code
command! -nargs=0 PrettierFormat :CocCommand prettier.formatFile
command! -nargs=0 PrettierCheck :CocCommand prettier.checkFormat

" Mappature aggiuntive per Prettier
nnoremap <leader>pr :CocCommand prettier.formatFile<CR>
nnoremap <leader>pc :CocCommand prettier.checkFormat<CR>

" Toggle format on save
function! ToggleFormatOnSave()
  if get(g:, 'format_on_save', 1)
    let g:format_on_save = 0
    echo "Format on save: OFF"
  else
    let g:format_on_save = 1
    echo "Format on save: ON"
  endif
endfunction

nnoremap <leader>tf :call ToggleFormatOnSave()<CR>

" Prettier status line integration (come VS Code)
function! PrettierStatus()
  if exists('*CocAction')
    let status = CocAction('extensionStats')
    for ext in status
      if ext.id == 'coc-prettier' && ext.state == 'activated'
        return ' ⚡'
      endif
    endfor
  endif
  return ''
endfunction

" Integrazione con Airline invece di sostituire statusline
if exists('*airline#add_statusline_func')
  call airline#add_statusline_func('PrettierStatus')
endif

echo "Configurazioni COC caricate!"