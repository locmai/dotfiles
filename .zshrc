# Debugging
if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

# Plugin manager
source $HOME/.zsh/zinit/zinit.zsh \
    || (git clone --depth 1 https://github.com/zdharma-continuum/zinit.git $HOME/.zsh/zinit && exec zsh)

# Theme
zinit light-mode depth=1 atload="source $HOME/.p10k.zsh" for romkatv/powerlevel10k

# Plugin list
zinit wait lucid light-mode depth=1 nocd for \
    atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' zdharma-continuum/fast-syntax-highlighting \
    atload='_zsh_autosuggest_start' zsh-users/zsh-autosuggestions \
    atload='MODE_CURSOR_VIINS="bar"; vim-mode-cursor-init-hook' softmoth/zsh-vim-mode

zinit wait lucid is-snippet for \
    https://github.com/ahmetb/kubectl-aliases/blob/master/.kubectl_aliases \
    https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.p10k.zsh


export PATH=$PATH:$HOME/google-cloud-sdk/bin:$HOME/go/bin
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

export PATH="/usr/local/opt/libpq/bin:$PATH"
# Aliases
source $HOME/.aliases
source $HOME/.aliases_axon

# Run `time ZSH_DEBUGRC=1 zsh -i -c exit` to debug
if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi

# source $HOME/random_bullshit.sh
export PATH=$PATH:/Users/lmai/.local/bin
