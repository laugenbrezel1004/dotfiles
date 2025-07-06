# ~/.zshrc
# Optimized Zsh configuration for productivity and efficiency.
# Tailored to tools in ~/.config (nvim, tmux, kitty, alacritty, bat, lsd, fastfetch).
# Includes advanced navigation, history, completions, and developer tools.

# --- Powerlevel10k Instant Prompt ---
# Enable Powerlevel10k instant prompt for faster shell startup.
# Must be near the top to avoid delays from console input.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# --- Zinit Plugin Manager ---
# Set Zinit directory for plugin management (XDG-compliant).
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install Zinit if not present, using shallow clone for speed.
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load Zinit to manage plugins and snippets.
source "${ZINIT_HOME}/zinit.zsh"

# --- Powerlevel10k Theme ---
# Load Powerlevel10k for a customizable, fast prompt.
zinit ice depth=1
zinit light romkatv/powerlevel10k

# --- Zsh Plugins ---
# Load plugins for enhanced functionality:
# - zsh-syntax-highlighting: Syntax highlighting for commands.
# - zsh-completions: Additional completion definitions.
# - zsh-autosuggestions: Suggests commands from history.
# - fzf-tab: Fuzzy search for tab completions.
# - zsh-history-substring-search: Substring-based history search.
# - zsh-vi-mode: Vim-like keybindings for advanced editing.
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit ice wait'0' lucid  # Load autosuggestions lazily for faster startup
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-history-substring-search
zinit light jeffreytse/zsh-vi-mode

# --- Oh My Zsh Snippets ---
# Load snippets for specific tools:
# - git: Git aliases and completions.
# - sudo: Toggle sudo with Esc-Esc.
# - archlinux: Arch Linux commands (if applicable).
# - aws: AWS CLI completions.
# - kubectl: Kubernetes CLI completions.
# - kubectx: Quick kubectl context switching.
# - command-not-found: Suggest packages for unknown commands.
# - docker: Docker CLI completions.
# - terraform: Terraform CLI completions.
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker
zinit snippet OMZP::terraform

# --- Completion Initialization ---
# Initialize completions efficiently, skipping recompilation if up-to-date.
autoload -Uz compinit
compinit -C
zinit cdreplay -q
zinit self-update

# --- Powerlevel10k Configuration ---
# Load custom Powerlevel10k settings (run `p10k configure` to customize).
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Aliases ---
# Source user-defined aliases from ~/.aliases if it exists.
[[ -f ~/.aliases ]] && source ~/.aliases

# --- Keybindings ---
# Use Emacs keybindings by default, but zsh-vi-mode can override for Vim users.
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
# Substring history search with up/down arrows.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# Fzf keybindings for advanced searching.
bindkey '^T' fzf-file-widget    # Ctrl+T: Search files
bindkey '^R' fzf-history-widget # Ctrl+R: Search history
bindkey '^G' fzf-cd-widget      # Ctrl+G: Search directories

# --- History Settings ---
# Configure history for better management and deduplication.
HISTSIZE=20000                # Store more history entries in memory.
SAVEHIST=$HISTSIZE            # Save all history entries to file.
HISTFILE=~/.zsh_history       # History file location.
setopt appendhistory          # Append to history file.
setopt sharehistory           # Share history across sessions.
setopt hist_ignore_space      # Ignore commands starting with a space.
setopt hist_ignore_all_dups   # Remove all duplicates.
setopt hist_save_no_dups      # Don't save duplicates.
setopt hist_ignore_dups       # Ignore consecutive duplicates.
setopt hist_find_no_dups      # Don't show duplicates in search.

# --- Atuin for Advanced History ---
# Replace default history with Atuin for syncable, searchable history.
#if [[ -x "$(command -v atuin)" ]]; then
 # eval "$(atuin init zsh --disable-up-arrow)"
 # eval "$(atuin init zsh --disable-up-arrow)"
#fi

# --- Shell Options ---
# Enhance shell usability with additional options.
setopt nocheckjobs            # Don't warn about background jobs on exit.
setopt autocd                 # Change to directories by typing their path.
setopt globdots               # Include dotfiles in globbing.
setopt extendedglob           # Enable advanced globbing patterns.
setopt notify                 # Report status of background jobs immediately.
#setopt command_time           # Show execution time for long-running commands (via plugin).

# --- Completion Styling ---
# Customize tab completion for better usability.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case-insensitive completion.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colorize completion lists.
zstyle ':completion:*' menu no                          # Disable default menu.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always $realpath' # Use eza for previews.
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'

# --- Shell Integrations ---
# Initialize fzf for fuzzy searching (files, history, etc.).
# if [[ -x "$(command -v fzf)" ]]; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border' # Customize fzf appearance.
# fi
# Initialize zoxide for smart directory navigation, overriding cd.
#if [[ -x "$(command -v zoxide)" ]]; then
#  eval "$(zoxide init zsh --cmd cd)"
#  alias j='z'  # Alias for quick zoxide jumps.
#fi
## Initialize direnv for project-specific environment variables.
#if [[ -x "$(command -v direnv)" ]]; then
#  eval "$(direnv hook zsh)"
#fi

# --- Pager Settings ---
# Use nvimpager or bat for man pages, falling back to less.
# if command -v bat >/dev/null 2>&1; then
#   export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# elif command -v nvimpager >/dev/null 2>&1; then
  export MANPAGER='nvimpager'
  export PAGER='nvimpager'
# else
#   export MANPAGER='less'
#   export PAGER='less'
# fi


# Set Neovim as default editor.
export EDITOR='nvim'
export VISUAL="$EDITOR"

# Set terminal based on available configs.
if [[ -d "$HOME/.config/kitty" ]]; then
  export TERMINAL='kitty'
elif [[ -d "$HOME/.config/alacritty" ]]; then
  export TERMINAL='alacritty'
fi
# Configure fzf for git integration.
if [[ -x "$(command -v fzf)" ]]; then
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  source <(fzf --zsh)
fi

# --- Taskwarrior Integration ---
# Add taskwarrior alias for task management.
# if command -v task >/dev/null 2>&1; then
#   alias t='task'
#   alias ta='task add'
#   alias tl='task list'
# fi

# --- Command Execution Time ---
# Show execution time for commands taking longer than 5 seconds.
zinit light popstas/zsh-command-time
export ZSH_COMMAND_TIME_MIN_SECONDS=5
export ZSH_COMMAND_TIME_MSG="Command took %s"

# --- Fastfetch System Info ---
# Display system info on startup with custom config.
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch --config "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null
fi

# --- Auto-Start Tmux ---
# Start tmux automatically in interactive sessions, unless already in tmux or VSCode.
if command -v tmux >/dev/null 2>&1 && [[ -z "$TMUX" && -z "$VSCODE_GIT_ASKPASS_NODE" ]]; then
  tmux attach-session -t default || tmux new-session -s default
fi
source <(fzf --zsh)
