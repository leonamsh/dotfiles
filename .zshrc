# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ------------------------------
# PATHS
# ------------------------------
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
# ------------------------------
# OH-MY-ZSH
# ------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins úteis
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
)

source $ZSH/oh-my-zsh.sh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet #run powerlevel quietly
# ------------------------------
# AUTO COMPLETION & HISTORY
# ------------------------------
autoload -Uz compinit
compinit -C

# Tamanho do histórico
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS

# ------------------------------
# OPÇÕES GERAIS
# ------------------------------
setopt AUTOCD             # cd sem precisar escrever "cd"
setopt PUSHD_IGNORE_DUPS  # Não repetir pastas no stack
setopt CORRECT            # Sugere correções de digitação
setopt EXTENDED_GLOB

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ------------------------------
# SUGESTÕES VISUAIS
# ------------------------------
# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# zsh-syntax-highlighting
# (deve ser carregado no final do arquivo!)

# ------------------------------
# ALIASES PRÁTICOS
# ------------------------------
alias ll='ls -lah --color=auto'
alias la='ls -A'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias y='yazi'

# ------------------------------
# P10K CONFIG (opcional)
# ------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------
# Rose Pine Toggle theme from shell
# ------------------------------

function toggle-theme() {
	current_theme=$(awk '$1=="include" {print $2}' "$HOME/.config/kitty/kitty.conf")
	new_theme="rose-pine.conf"

	if [ "$current_theme" = "rose-pine.conf" ]; then
		new_theme="rose-pine-dawn.conf"
	fi

	# Set theme for active sessions. Requires `allow_remote_control yes`
	kitty @ set-colors --all --configured "~/.config/kitty/$new_theme"

	# Update config for persistence
	sed -i '' -e "s/include.*/include $new_theme/" "$HOME/.config/kitty/kitty.conf"
}

## Useful aliases
#Leonam
# ------------------------------
# updates 
# ------------------------------
alias S='sudo pacman -S --noconfirm --needed'
alias pS='paru -S --noconfirm --needed'
alias Ss='pacman -Ss'
alias pSs='paru -Ss'
alias dins='sudo dnf install -y'
alias dsrc='dnf search'
alias fsrc='flatpak search'
alias fins='flatpak install -y'
alias upds='~/.config/autostart/xinputI3.sh'
alias update='/run/media/lm/dev/gitlab/scripts/1-fedora/update.sh'
alias limpao='/run/media/lm/dev/gitlab/scripts/1-fedora/update-clean-arch.sh'
alias cdg='cd .config'
alias srcfish='source ~/.config/fish/config.fish'
alias srczsh='source ~/.zshrc'
alias clone='git clone'
alias cddev='cd /run/media/lm/dev/'
alias gitr='git remote set-url origin'
# ------------------------------
# doom aliases 
# ------------------------------
alias doomsync='~/.config/emacs/bin/doom sync'
alias doomupd='~/.config/emacs/bin/doom upgrade'
alias doomdoc='~/.config/emacs/bin/doom doctor'
alias doompurge='~/.config/emacs/bin/doom purge'
alias dinstall='emacs -nw /run/media/lm/dev/gitlab/scripts/1-fedora/post-install.sh'
alias emacs='emacs -nw'
# ------------------------------
# change directory aliases 
# ------------------------------
alias cdaula='cd /run/media/lm/dev/maisPraTi/'
alias naula='nvim /run/media/lm/dev/maisPraTi/'
# ------------------------------
# nvim aliases
# ------------------------------
alias v='nvim'
alias nl='nviml'
alias vim='nvim'
alias nkitty='nvim ~/.config/kitty/kitty.conf'
alias nalac='nvim ~/.config/alacritty/alacritty.toml'
alias nwez='nvim ~/.config/wezterm/wezterm.lua'
alias ngtty='nvim ~/.config/ghostty/config'
alias nfish='nvim ~/.config/fish/config.fish'
alias nqtile='nvim ~/.config/qtile/config.py'
alias nzsh='nvim ~/.zshrc'
alias ninstall='nvim /run/media/lm/dev/gitlab/scripts/1-fedora/post-install.sh'
alias ngit='nvim /run/media/lm/dev/gitlab'
alias nvimz="env NVIM_APPNAME=nvim-lazar nvim"
alias nvima="env NVIM_APPNAME=astronvim nvim"
alias nvimc="env NVIM_APPNAME=nvchad nvim"
alias nviml="env NVIM_APPNAME=lazynvim nvim"
# ------------------------------
# other aliases 
# ------------------------------
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons=always' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons=always' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons=always' # long format
alias lt='eza -aT --color=always --group-directories-first --icons=always' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles
eval "$(zoxide init zsh)"

alias cd="z"

# Common use
alias stowa='stow . --adopt'
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short' # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl" # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages

# Cleanup orphaned packages
# alias cleanup='sudo pacman -Rs $(sudo pacman -Qdtq)'
# alias cleanup='ORPHANS=$(sudo pacman -Qdtq); if [ -n "$ORPHANS" ]; then sudo pacman -Rs $ORPHANS; else echo "No orphaned packages to remove."; fi'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# ------------------------------
# FIM
# ------------------------------

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Shell wrapper
# We suggest using this 'y' shell wrapper that provides the ability to change the current working directory when exiting Yazi.
export EDITOR=nvim
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-foward
