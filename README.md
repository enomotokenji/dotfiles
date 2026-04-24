# dotfiles

Cross-platform dotfiles configuration for Ubuntu and macOS.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks the dotfiles into `$HOME`, then installs oh-my-zsh, vim,
and Vundle (with the plugins declared in `.vimrc`) if they are not already
present. Any pre-existing regular file at a target path is backed up as
`*.bak` before the symlink is created. Re-running is safe.

On Linux, install the vim build dependencies before running the script:

```bash
sudo apt-get install -y git build-essential libncurses-dev \
  liblua5.3-dev lua5.3 python3-dev libgtk-3-dev libxt-dev
```

## Uninstall

```bash
./uninstall.sh
```

Removes only the symlinks this repo created, and restores any `*.bak` backup
taken at install time. `~/.oh-my-zsh`, the vim binary, and `~/.vim/bundle`
are left in place — remove them by hand if you want a clean slate.

## Supported OS

- macOS: vim installed via Homebrew
- Ubuntu / Linux: vim built from source (latest `master` via `git clone`)
