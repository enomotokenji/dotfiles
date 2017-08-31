DOTFILES_EXCLUDES := .DS_Store .git
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: deploy init ## Run make deploy init

deploy:
    @$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	ln -sf ~/dotfiles/colors ~/.vim

init:
    @$(foreach val, $(wildcard ./init/*.sh), sh $(val);)
