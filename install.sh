#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
UNAME="$(uname)"

echo "==> Installing dotfiles from $DOTFILES_DIR"

# 1. Symlink dotfiles into $HOME. Backs up any pre-existing regular file as *.bak
#    so we never silently clobber user data.
shopt -s nullglob
for src in "$DOTFILES_DIR"/.??*; do
    name="$(basename "$src")"
    case "$name" in
        .git|.DS_Store) continue ;;
    esac

    target="$HOME/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up existing $target -> $target.bak"
        mv "$target" "$target.bak"
    fi
    ln -sfn "$src" "$target"
    echo "  linked $target -> $src"
done
shopt -u nullglob

# 2. Vim colors
mkdir -p "$HOME/.vim/colors"
ln -sfn "$DOTFILES_DIR/vim/colors/iceberg.vim" "$HOME/.vim/colors/iceberg.vim"
echo "  linked $HOME/.vim/colors/iceberg.vim"

# 3. oh-my-zsh (required by .zshrc)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing oh-my-zsh"
    # --unattended keeps our symlinked .zshrc and skips chsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "==> oh-my-zsh already installed"
fi

# 4. Vim
if ! command -v vim >/dev/null 2>&1; then
    echo "==> Installing vim"
    bash "$DOTFILES_DIR/initfiles/install_vim.sh"
else
    echo "==> vim already available ($(command -v vim))"
fi

# 5. Vundle + plugins from .vimrc
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    echo "==> Installing Vundle and plugins"
    bash "$DOTFILES_DIR/initfiles/install_vundle.sh"
else
    echo "==> Vundle already installed (run 'vim +PluginInstall +qall' to refresh plugins)"
fi

echo "==> Done. Restart your shell to pick up changes."
