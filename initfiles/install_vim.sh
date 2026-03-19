# Reference: https://gist.github.com/michiomochi/9743293

mkdir -p ~/.local/src

# ---
# Installing lua
# ---

cd ~/.local/src
wget https://www.lua.org/ftp/lua-5.4.7.tar.gz
tar xvf lua-5.4.7.tar.gz
cd ~/.local/src/lua-5.4.7
make linux MYLIBS="-L ${HOME}/.local/lib -ltermcap"
make install INSTALL_TOP=${HOME}/.local


# ---
# Installing vim
# ---

cd ~/.local/src
wget https://ftp.vim.org/pub/vim/unix/vim-9.1.tar.bz2
tar xvf vim-9.1.tar.bz2
cd vim91
./configure --prefix=${HOME}/.local --with-features=huge --enable-gui=gtk2 --enable-multibyte=yes --enable-python3interp=yes --enable-luainterp=yes --with-lua-prefix=${HOME}/.local

make
make install




