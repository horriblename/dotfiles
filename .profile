#!/bin/sh

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="${EDITOR:-nvim}"
export PAGER=bat
export MANPAGER='bat --decorations=never'

### App Settings
#
export GTK_THEME=Adwaita:dark
export QT_QPA_PLATFORMTHEME=kde
#export QT_STYLE_OVERRIDE=kvantum
export MOZ_ENABLE_WAYLAND="${WAYLAND_DISPLAY:+1}"

#export QSG_RENDER_LOOP=basic

#export GTK_IM_MODULE=fcitx
#export QT_IM_MODULE=fcitx
#export XMODIFIERS=\@im=fcitx

### Proper XDG Directories usage

export ANDROID_HOME="${XDG_DATA_HOME}/android"
export CABAL_CONFIG="${XDG_CONFIG_HOME}/cabal/config"
export CABAL_DIR="${XDG_DATA_HOME}/cabal"
export GHCUP_USE_XDG_DIRS=true
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export GOPATH="${XDG_DATA_HOME}/go"
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export XCURSOR_PATH="/usr/share/icons:${XDG_DATA_HOME}/icons"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
export KDEHOME="${XDG_CONFIG_HOME}/kde4"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export TERMINFO="${XDG_DATA_HOME}/terminfo"
export TERMINFO_DIRS="${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export PIP_REQUIRE_VIRTUALENV=true
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export WINEPREFIX="${XDG_DATA_HOME}/wine"
#export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"
export _ZL_DATA="$XDG_DATA_HOME/zlua"

export PATH="$HOME/.local/bin:$GOPATH/bin:$CARGO_HOME/bin:$PATH"

[ -f "$XDG_CONFIG_HOME/aliases" ] && source "$XDG_CONFIG_HOME/aliases"
