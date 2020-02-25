nmap <silent><Leader>N :SyntasticCheck<CR>:Errors<CR>

let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['php'],
            \ 'passive_filetypes': ['python'] }

let g:syntastic_php_phpcs_args = '--standard=~/.config/phpcs/ruleset.xml'
let g:syntastic_php_checkers = ['php', 'phpcs']

let g:syntastic_check_on_open = 1

let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol  = '⚡'
let g:syntastic_style_warning_symbol  = '⚡'
