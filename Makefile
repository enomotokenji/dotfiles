DOTFILES_EXCLUDES := .DS_Store .git
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: deploy ## Run make deploy init

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

#init:
#	@$(foreach val, $(wildcard ./initfiles/*.sh), sh $(val);)

clean:
	@$(foreach val, $(DOTFILES_FILES), unlink $(HOME)/$(val);)
