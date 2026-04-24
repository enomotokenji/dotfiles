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

# 5. vim-plug + plugins from .vimrc
PLUG_VIM="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_VIM" ]; then
    echo "==> Installing vim-plug"
    curl -fLo "$PLUG_VIM" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
if [ ! -d "$HOME/.vim/plugged" ] || [ -z "$(ls -A "$HOME/.vim/plugged" 2>/dev/null)" ]; then
    echo "==> Installing vim plugins"
    vim +PlugInstall +qall
else
    echo "==> vim plugins already installed (use ./update.sh to refresh)"
fi

# 6. oh-my-tmux. ~/.tmux.conf.local is symlinked from this repo by step 1
#    above; here we clone the upstream oh-my-tmux and link ~/.tmux.conf to it.
OH_MY_TMUX_DIR="$HOME/.tmux"
if [ ! -d "$OH_MY_TMUX_DIR" ]; then
    echo "==> Cloning oh-my-tmux into $OH_MY_TMUX_DIR"
    git clone https://github.com/gpakosz/.tmux.git "$OH_MY_TMUX_DIR"
else
    echo "==> oh-my-tmux already at $OH_MY_TMUX_DIR (cd there and 'git pull' to update)"
fi

tmux_target="$HOME/.tmux.conf"
if [ -e "$tmux_target" ] && [ ! -L "$tmux_target" ]; then
    echo "  Backing up existing $tmux_target -> $tmux_target.bak"
    mv "$tmux_target" "$tmux_target.bak"
fi
ln -sfn "$OH_MY_TMUX_DIR/.tmux.conf" "$tmux_target"
echo "  linked $tmux_target -> $OH_MY_TMUX_DIR/.tmux.conf"

# 7. Claude Code and Codex CLI config trees. We link each entry under
#    claude/ and codex/ individually into ~/.claude and ~/.codex so that
#    runtime state the tools write (projects/, todos/, shell-snapshots/,
#    ...) stays outside the repo.
for subtree in claude codex; do
    src_root="$DOTFILES_DIR/$subtree"
    dst_root="$HOME/.$subtree"
    [ -d "$src_root" ] || continue
    mkdir -p "$dst_root"
    echo "==> Linking $subtree config into $dst_root"
    for src in "$src_root"/*; do
        [ -e "$src" ] || continue
        name="$(basename "$src")"
        target="$dst_root/$name"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            echo "  Backing up existing $target -> $target.bak"
            mv "$target" "$target.bak"
        fi
        ln -sfn "$src" "$target"
        echo "  linked $target -> $src"
    done
done

# 8. Shared skills: a single skills/ directory wired into both Claude Code
#    and Codex, since both honour the Agent Skills SKILL.md format.
if [ -d "$DOTFILES_DIR/skills" ]; then
    echo "==> Linking shared skills into Claude and Codex"
    for dst_root in "$HOME/.claude" "$HOME/.codex"; do
        mkdir -p "$dst_root"
        target="$dst_root/skills"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            echo "  Backing up existing $target -> $target.bak"
            mv "$target" "$target.bak"
        fi
        ln -sfn "$DOTFILES_DIR/skills" "$target"
        echo "  linked $target -> $DOTFILES_DIR/skills"
    done
fi

echo "==> Done. Restart your shell to pick up changes."
