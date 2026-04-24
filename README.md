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

### Claude Code / Codex CLI

`claude/` and `codex/` hold the checked-in config for each agent CLI. On
install their contents are symlinked individually into `~/.claude/` and
`~/.codex/`, so runtime state the tools write (`projects/`, `todos/`,
`shell-snapshots/`, `settings.local.json`, ...) stays outside the repo.

`skills/` at the repo root is a **shared** skills directory: `install.sh`
points both `~/.claude/skills` and `~/.codex/skills` at it. Both tools read
the same [Agent Skills](https://agentskills.io) `SKILL.md` format (`name` +
`description` frontmatter), so one directory serves both.

Before the first install, copy any existing configs you want to keep into
the repo so they are preserved rather than replaced:

```bash
cp ~/.claude/settings.json   claude/settings.json    # if exists
cp -R ~/.claude/agents/.     claude/agents/          # if exists
cp -R ~/.claude/commands/.   claude/commands/        # if exists
cp ~/.codex/config.toml      codex/config.toml       # if exists
# ...and any skills from ~/.claude/skills or ~/.codex/skills into ./skills/
```

Review for secrets before committing. Anything already present at a target
path is backed up as `*.bak` at install time and restored by `uninstall.sh`.

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
