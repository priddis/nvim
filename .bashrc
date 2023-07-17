test -s ~/.alias && . ~/.alias || true
PS1='\w> '

#programs to install 
#fzf
#fd
#ccache
#zoxide
#neovim
#wezterm
alias ll='ls -lah'
alias fi='find . -type f'
alias find='find . -type f'
alias h='history | grep'

#git aliases
alias gc='git commit -m'
alias gb='git checkout'
alias gnew='git checkout -b'
alias gp='git pull'
alias b='./gradlew b -x tests'
alias t='./gradlew b'
