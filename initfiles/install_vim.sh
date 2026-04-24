#!/bin/bash
set -e

# Detect OS
UNAME="$(uname)"

if [[ "$UNAME" == "Darwin" ]]; then
    # macOS: Use Homebrew to install vim
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    echo "Installing Vim on macOS via Homebrew..."
    brew install vim

elif [[ "$UNAME" == "Linux" ]]; then
    # Linux: Build latest Vim from source
    echo "Installing Vim on Linux from source..."

    # Required dev packages (Debian/Ubuntu):
    #   sudo apt-get install -y git build-essential libncurses-dev \
    #     liblua5.3-dev lua5.3 python3-dev libgtk-3-dev libxt-dev
    # On other distros, install the equivalents before running this script.

    SRC_DIR="$HOME/.local/src"
    mkdir -p "$SRC_DIR"
    cd "$SRC_DIR"

    if [ -d "$SRC_DIR/vim" ]; then
        echo "Updating existing vim source checkout..."
        cd "$SRC_DIR/vim"
        git pull
    else
        echo "Cloning vim source..."
        git clone https://github.com/vim/vim.git "$SRC_DIR/vim"
        cd "$SRC_DIR/vim"
    fi

    ./configure \
        --prefix="$HOME/.local" \
        --with-features=huge \
        --enable-multibyte \
        --enable-python3interp=yes \
        --enable-luainterp=yes \
        --enable-gui=gtk3

    make
    make install

else
    echo "Unsupported OS: $UNAME"
    exit 1
fi

echo "Vim installation completed for $UNAME"
