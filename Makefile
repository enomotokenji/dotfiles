DOTFILES_EXCLUDES := .DS_Store .git
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: deploy init ## Run make deploy init

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	ln -sf ~/dotfiles/colors/solarized.vim ~/.vim/colors/solarized.vim

init:
	@$(foreach val, $(wildcard ./initfiles/*.sh), sh $(val);)
