command! -nargs=0 -range -bar OpenContextMenu :call OpenContextMenu()
function OpenContextMenu()
    let content = [
                \ ["Replace \" to '\tcs\"'", 'echo 100' ],
                \ ["Find in &Defintion\t\\cd", 'echo 400' ],
                \ ["Search &References\t\\cr", 'echo 500'],
                \ ['-'],
                \ ["&Documentation\t\\cm", 'echo 600'],
                \ ]

    let opts = {'index':g:quickui#context#cursor}

    call QuickThemeChange('')
    call quickui#context#open(content, opts)
endfunction

map <F15> :OpenContextMenu<cr>
