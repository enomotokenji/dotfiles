# dotfiles

Cross-platform dotfiles configuration for Ubuntu and macOS

## Setup

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Deploy dotfiles
make deploy

# Install Vim (optional)
sh initfiles/install_vim.sh

# Install dein.vim (optional)
sh initfiles/install_dein.sh
```

## Supported OS

- Ubuntu/Linux: Build and install Vim from source
- macOS: Install Vim via Homebrew