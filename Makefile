DOTFILES_EXCLUDES := .DS_Store .git
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: deploy init ## Run make deploy init

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	ln -sf ~/dotfiles/vim/colors/solarized.vim ~/.vim/colors/solarized.vim
	ln -sf ~/dotfiles/vim/rc/dein.toml ~/.vim/rc/dein.toml
	ln -sf ~/dotfiles/vim/rc/dein_lazy.toml ~/.vim/rc/dein_lazy.toml

init:
	@$(foreach val, $(wildcard ./initfiles/*.sh), sh $(val);)

clean:
	@$(foreach val, $(DOTFILES_FILES), unlink $(HOME)/$(val);)
	unlink ~/.vim/colors/solarized.vim
	unlink ~/.vim/rc/dein.toml
	unlink ~/.vim/rc/dein_lazy.toml
	rm -rf ~/.local/