#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Updating dotfiles repo ($DOTFILES_DIR)"
git -C "$DOTFILES_DIR" pull --ff-only

if [ -d "$HOME/.oh-my-zsh/.git" ]; then
    echo "==> Updating oh-my-zsh"
    git -C "$HOME/.oh-my-zsh" pull --ff-only
else
    echo "==> oh-my-zsh not a git checkout, skipping (run install.sh to bootstrap)"
fi

if [ -d "$HOME/.tmux/.git" ]; then
    echo "==> Updating oh-my-tmux"
    git -C "$HOME/.tmux" pull --ff-only
else
    echo "==> oh-my-tmux not a git checkout, skipping (run install.sh to bootstrap)"
fi

if command -v vim >/dev/null 2>&1 && [ -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "==> Updating vim plugins (vim-plug)"
    vim +PlugUpdate +qall
else
    echo "==> vim or vim-plug missing, skipping plugin update"
fi

echo "==> Done."
