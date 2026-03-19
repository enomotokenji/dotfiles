DOTFILES_EXCLUDES := .DS_Store .git .claude
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: deploy ## Run make deploy init

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	mkdir -p $(HOME)/.vim/colors
	ln -sf $(DOTFILES_DIR)/vim/colors/iceberg.vim $(HOME)/.vim/colors/iceberg.vim
	@if [ ! -d $(HOME)/.vim/bundle/Vundle.vim ]; then \
		git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim; \
	fi

#init:
#	@$(foreach val, $(wildcard ./initfiles/*.sh), sh $(val);)

clean:
	@$(foreach val, $(DOTFILES_FILES), unlink $(HOME)/$(val);)
	unlink ~/.vim/colors/iceberg.vim
