# Reference: https://gist.github.com/michiomochi/9743293

mkdir -p ~/.local/src

# ---
# Installing lua
# ---

cd ~/.local/src
wget http://www.lua.org/ftp/lua-5.2.3.tar.gz
tar xvf lua-5.2.3.tar.gz
cd ~/.local/src/lua-5.2.3
make linux MYLIBS="-L /home/vagrant/local/lib -ltermcap"
make install INSTALL_TOP=${HOME}/.local


# ---
# Installing vim
# ---

cd ~/.local/src
wget http://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
tar xvf vim-7.4.tar.bz2
cd vim74
./configure --prefix=${HOME}/.local --with-features=huge --enable-gui=gtk2 --enable-multibyte=yes --enabel-python3interp=yes --enable-luainterp=yes --with-lua-prefix=${HOME}/.local

make
make install




