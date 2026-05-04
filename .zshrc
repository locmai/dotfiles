# Debugging
if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

# Powerlevel10k instant prompt. Keep near top; nothing above should produce output.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Auto-recompile .zwc bytecode when source edited
for _f in $HOME/.zshrc $HOME/.p10k.zsh $HOME/.aliases $HOME/.aliases_axon; do
  [[ -f $_f && ( ! -f $_f.zwc || $_f -nt $_f.zwc ) ]] && zcompile -R $_f
done
unset _f

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


export BUN_INSTALL="$HOME/.bun"
export PATH=$PATH:$HOME/google-cloud-sdk/bin:$HOME/go/bin
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$PATH:$HOME/.local/bin

# Claude Code
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Aliases
source $HOME/.aliases
source $HOME/.aliases_axon

# Run `time ZSH_DEBUGRC=1 zsh -i -c exit` to debug
if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
