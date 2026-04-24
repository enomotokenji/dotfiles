# dotfiles

Cross-platform dotfiles configuration for Ubuntu and macOS.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks the dotfiles into `$HOME`, then installs oh-my-zsh, vim,
vim-plug (with the plugins declared in `.vimrc`), and oh-my-tmux (cloned to
`~/.tmux/`) if they are not already present. Any pre-existing regular file at
a target path is backed up as `*.bak` before the symlink is created.
Re-running is safe.

Tmux config lives upstream in [gpakosz/.tmux](https://github.com/gpakosz/.tmux);
local overrides go in `.tmux.conf.local` in this repo.

On Linux the vim build is from source; the script auto-installs the required
dev packages via `apt-get` (prompting for `sudo`). On non-Debian distros,
install the equivalents (ncurses, lua 5.3, python3 headers, gtk3, libXt) by
hand before running.

## Update

```bash
./update.sh
```

Pulls the dotfiles repo, oh-my-zsh, and oh-my-tmux from their upstreams and
runs `:PlugUpdate` for vim plugins. Skips anything that is not installed.

## Uninstall

```bash
./uninstall.sh
```

Removes only the symlinks this repo created, and restores any `*.bak` backup
taken at install time. `~/.oh-my-zsh`, `~/.tmux/` (oh-my-tmux clone), the vim
binary, and `~/.vim/plugged` are left in place — remove them by hand if you
want a clean slate.

## Supported OS

- macOS: vim installed via Homebrew
- Ubuntu / Linux: vim built from source (latest `master` via `git clone`)
