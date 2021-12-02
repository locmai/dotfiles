# Plugin manager
source $HOME/.zsh/zinit/zinit.zsh || git clone --depth 1 https://github.com/zdharma/zinit.git $HOME/.zsh/zinit

# Theme
zinit ice depth=1 atload="source $HOME/.p10k.zsh"
zinit light romkatv/powerlevel10k

# Plugin list
# Plugin list
zinit wait lucid light-mode depth=1 for \
    atinit="zicompinit" zdharma/fast-syntax-highlighting \
    atload="_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    hlissner/zsh-autopair \
    softmoth/zsh-vim-mode
zinit wait lucid is-snippet for \
    https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh \
    https://github.com/ahmetb/kubectl-aliases/blob/master/.kubectl_aliases \
    as='completion' https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

function tolab(){
	ssh -i /home/locmai/.ssh/id_rsa_lmlabs node0$1
}

