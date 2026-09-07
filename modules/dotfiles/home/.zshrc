# Debugging
if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

# Powerlevel10k instant prompt. Keep near top; nothing above should produce output.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Auto-recompile .zwc bytecode when source edited
for _f in $HOME/.zshrc $HOME/.p10k.zsh $HOME/.aliases $HOME/.aliases_axon $HOME/.sh_functions; do
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

# Nix profiles come first so system packages win over anything installed ad hoc
export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
export PATH=$PATH:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Claude Code
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Shared shell config. .aliases_axon holds work-only aliases and is not
# tracked in this repository, so source it only when present.
for _f in $HOME/.aliases $HOME/.sh_functions $HOME/.aliases_axon; do
  [[ -f $_f ]] && source $_f
done
unset _f

# Run `time ZSH_DEBUGRC=1 zsh -i -c exit` to debug
if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi

# Completions for tools that manage their own installs
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
