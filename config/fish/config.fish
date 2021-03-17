set -gx PATH $PATH ~/bin
set -gx TERM xterm-256color
set -gx EDITOR xvim
set -gx GOPATH ~/go
set -gx XDG_CACHE_HOME ~/.cache
set -gx CHEATCOLORS true
set -gx NVIM_LISTEN_ADDRESS /tmp/nvimsocket

function r
    alias r "ranger"
    if not set -q RANGER_LEVEL
        ranger
    else
        exit
    end
end

alias l "ls --color=auto -lh"
alias sp "sudo pacman"
alias rm "rm -i"
alias gs "git status "
alias ga "git add "
alias gb "git branch "
alias gc "git commit"
alias gd "git diff"
alias gito "git checkout "
alias gk "gitk --all&"
alias gx "gitx --all"
alias crontab "set -l VISUAL vim; set -l EDITOR vim; /usr/bin/crontab"
alias v "vagrant"
alias vssh "vagrant ssh"
alias wtmux "tmux has-session -t work >> /dev/null 2>&1 ; and tmux attach-session -t work; or tmux new-session -s work"

alias awesome-restart="echo 'awesome.restart()' | awesome-client"

alias reboot "sudo systemctl reboot"
alias poweroff "sudo systemctl poweroff"
alias halt "sudo systemctl halt"
