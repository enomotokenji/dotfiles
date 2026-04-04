#!/bin/bash
# Reference: https://gist.github.com/michiomochi/9743293

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
    # Linux: Build from source
    echo "Installing Vim on Linux from source..."
    
    mkdir -p ~/.local/src
    
    # ---
    # Install Lua
    # ---
    
    cd ~/.local/src
    wget http://www.lua.org/ftp/lua-5.2.3.tar.gz
    tar xvf lua-5.2.3.tar.gz
    cd ~/.local/src/lua-5.2.3
    make linux MYLIBS="-L /home/vagrant/local/lib -ltermcap"
    make install INSTALL_TOP=${HOME}/.local
    
    
    # ---
    # Install Vim
    # ---
    
    cd ~/.local/src
    wget http://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
    tar xvf vim-7.4.tar.bz2
    cd vim74
    ./configure --prefix=${HOME}/.local --with-features=huge --enable-gui=gtk2 --enable-multibyte=yes --enable-python3interp=yes --enable-luainterp=yes --with-lua-prefix=${HOME}/.local
    
    make
    make install
    
else
    echo "Unsupported OS: $UNAME"
    exit 1
fi

echo "Vim installation completed for $UNAME"




