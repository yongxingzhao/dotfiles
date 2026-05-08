source $HOME/.config/shell/env
# ===================
# ***** @System *****
# ===================
#
# export PATH=$(echo $PATH | tr : "\n"| sort | uniq | tr "\n" :)
export PATH=$HOME/bin:/usr/local/bin:$PATH
# export XDG_RUNTIME_DIR="/tmp/runtime-$UID"

# Zsh
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"


# ============================
# ****** @User HOMEBREW ******
# ============================

# homebrew aliyun repository
# export GOROOT=/opt/homebrew/bin
# export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api" 
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"

# =========================
# ****** @Git ******
# =========================
#
export GIT_CONFIG_GLOBAL="$HOME/.config/git/config"
export GIT_CREDENTIALS="$HOME/.config/git/credentials"
export GIT_IGNORE="$HOME/.config/git/ignore"

# =========================
# ****** @User Go ******
# =========================
#
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export PATH=$GOROOT:$GOPATH/bin:$PATH

export GVM_ROOT="$HOME/.gvm"
export PATH=$GVM_ROOT/bin:$PATH

# =========================
# ****** @User Cargo ******
# =========================
#
export PATH=$HOME/.cargo/bin:$PATH

# =========================
# ****** @User Nodejs ******
# =========================
#
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"

# ==========================
# ****** @User SDKMAN ******
# ==========================
#
export SDKMAN_DIR="/opt/sdkman"

# ==========================
# ****** @User Zellij ******
# ==========================
#
export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"
export ZELLIJ_AUTO_ATTACH=true

# =================================
# ****** @Plugin zap-zsh/vim ******
# =================================
#
# will escape back into normal mode upon pressing jk.
export VI_MODE_ESC_INSERT="jk"


# =============================
# ****** @Theme starship ******
# =============================
#
# wilmal, blazing-fast, and infinitely customizable prompt for any shell!
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

