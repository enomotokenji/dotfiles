#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Uninstalling dotfiles symlinks pointing at $DOTFILES_DIR"

# Only remove symlinks that point at files inside this repo. Leave anything
# else (regular files, symlinks to elsewhere) untouched.
shopt -s nullglob
for src in "$DOTFILES_DIR"/.??*; do
    name="$(basename "$src")"
    case "$name" in
        .git|.DS_Store) continue ;;
    esac

    target="$HOME/$name"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
        rm "$target"
        echo "  removed $target"

        # Restore a backup we created during install, if present
        if [ -e "$target.bak" ]; then
            mv "$target.bak" "$target"
            echo "    restored $target from $target.bak"
        fi
    fi
done
shopt -u nullglob

# iceberg colorscheme symlink
iceberg="$HOME/.vim/colors/iceberg.vim"
if [ -L "$iceberg" ] && [ "$(readlink "$iceberg")" = "$DOTFILES_DIR/vim/colors/iceberg.vim" ]; then
    rm "$iceberg"
    echo "  removed $iceberg"
fi

# ~/.tmux.conf points at the oh-my-tmux clone, not at this repo, so the loop
# above does not catch it.
tmux_target="$HOME/.tmux.conf"
if [ -L "$tmux_target" ] && [ "$(readlink "$tmux_target")" = "$HOME/.tmux/.tmux.conf" ]; then
    rm "$tmux_target"
    echo "  removed $tmux_target"
    if [ -e "$tmux_target.bak" ]; then
        mv "$tmux_target.bak" "$tmux_target"
        echo "    restored $tmux_target from $tmux_target.bak"
    fi
fi

# Claude Code and Codex config trees — symmetric to the install step.
for subtree in claude codex; do
    src_root="$DOTFILES_DIR/$subtree"
    dst_root="$HOME/.$subtree"
    [ -d "$src_root" ] || continue
    [ -d "$dst_root" ] || continue
    for src in "$src_root"/*; do
        [ -e "$src" ] || continue
        name="$(basename "$src")"
        target="$dst_root/$name"
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
            rm "$target"
            echo "  removed $target"
            if [ -e "$target.bak" ]; then
                mv "$target.bak" "$target"
                echo "    restored $target from $target.bak"
            fi
        fi
    done
done

# Shared skills symlinks in ~/.claude and ~/.codex.
for dst_root in "$HOME/.claude" "$HOME/.codex"; do
    target="$dst_root/skills"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$DOTFILES_DIR/skills" ]; then
        rm "$target"
        echo "  removed $target"
        if [ -e "$target.bak" ]; then
            mv "$target.bak" "$target"
            echo "    restored $target from $target.bak"
        fi
    fi
done

echo "==> Done."
echo "    oh-my-zsh (~/.oh-my-zsh), oh-my-tmux (~/.tmux), vim, vim-plug"
echo "    (~/.vim/autoload/plug.vim), and ~/.vim/plugged were left in place."
echo "    Claude/Codex runtime state (projects/, todos/, ...) was not touched."
