# =====================
# ****** @System ******
# =====================
alias md="mkdir -pv"
alias rd="rmdir -pv"
alias zshrc="vim $HOME/.config/zsh/zshrc"

# ==========================
# ****** @Command eza ******
# ==========================
# eza 替代 ls 系列
alias ls='eza --icons=always --color=always --group-directories-first'
alias ll='eza -l --icons=always --color=always --group-directories-first --git'
alias la='eza -la --icons=always --color=always --group-directories-first --git'
alias l.='eza -d .* --icons=always --color=always'
alias lt='eza -T --icons=always --color=always --level=2'  # 树形，默认2层
alias lta='eza -Ta --icons=always --color=always --level=2'
# 更详细信息（含权限、用户、inode等）
alias lll='eza -lha --icons=always --color=always --git --extended'

# ===========================
# ****** @Command vim ******
# ===========================
alias vimrc="vim $HOME/.vim/vimrc"

# ===========================
# ****** @Command nvim ******
# ===========================
alias v="nvim"
alias vi="sudo nvim"
alias nv="v ~/.config/nvim/"
alias nvimrc="v ~/.config/nvim/init.lua"

# ==============================
# ****** @Command chezmoi ******
# ==============================
#
alias ce="chezmoi edit"
alias ca="chezmoi add"

# ==============================
# ****** @Command joshuto ******
# ==============================
alias l="joshuto"


# ****** @Command tmux ******
# ===========================
alias ta="tmux attach -t"
alias tn="tmux new -s"
alias tls="tmux ls"
alias tks="tmux kill-session -t"

# ===========================
# ****** @Command lazygit ******
# ===========================
alias lg="lazygit"

