set -gx PATH $PATH ~/bin
set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx XDG_CACHE_HOME ~/.cache
set -gx CHEATCOLORS true

function r
    alias r ranger
    if not set -q RANGER_LEVEL
        ranger
    else
        exit
    end
end

if type -q exa
    alias ls "exa --header --icons"
    alias ll "ls -l -g"
    alias lla "ll -a"
end

if type -q bat
    alias cat bat
end

if type -q nvim
    alias vim nvim
end

if type -q duf
    alias df duf
end

alias cheat "cheat -c"

alias rembox "cd ~/tmp/rembox"
alias work "cd ~/work/vm"

alias l "ls --color=auto -lh"
alias sp "sudo pacman"
alias rm "rm -i"
alias gs "git status "
alias ga "git add "
alias gb "git branch "
alias gc "git commit"
alias gd "git diff"
alias gito "git checkout "

alias crontab "set -l VISUAL vim; set -l EDITOR vim; /usr/bin/crontab"
alias v vim
alias vssh "vagrant ssh"

alias awesome-restart="echo 'awesome.restart()' | awesome-client"

alias reboot "sudo systemctl reboot"
alias poweroff "sudo systemctl poweroff"
alias halt "sudo systemctl halt"

set fzf_fd_opts --hidden --exclude=.git

if status is-interactive
    and not set -q TMUX
    exec tmux
end
