SHELL				:= $(shell which zsh)

LIBRARY_DIR			:= $(HOME)/Library
APP_SUPPORT_DIR		:= $(LIBRARY_DIR)/Application\ Support

XDG_CACHE_HOME		:= $(HOME)/.cache
XDG_CONFIG_HOME		:= $(HOME)/.config
XDG_BIN_HOME		:= $(HOME)/.local/bin
XDG_DATA_HOME		:= $(HOME)/.local/share
XDG_STATE_HOME		:= $(HOME)/.local/state

ZDOTDIR				:= $(XDG_CONFIG_HOME)/zsh

GIT_CONFIGS_DIR		:= $(XDG_CONFIG_HOME)/git

VSCODE_PREFS_DIR	:= $(APP_SUPPORT_DIR)/Code/User

ADOBE_SUPPORT_DIR	:= $(APP_SUPPORT_DIR)/Adobe
CAMERA_RAW_SRCS		:= $(wildcard ./Adobe/CameraRaw/*)
LIGHTROOM_SRCS		:= $(wildcard ./Adobe/Lightroom/*)

ADOBE_TARGETS		:= $(pathsubst ./Adobe/%, $(ADOBE_SUPPORT_DIR)/%, \
						$(CAMERA_RAW_SRCS) $(LIGHTROOM_SRCS))

C1_SUPPORT_DIR		:= $(APP_SUPPORT_DIR)/Capture\ One

MAYA_PREFS_DIR		:= $(LIBRARY_DIR)/Preferences/Autodesk/maya
MAYA_VERSION		:= 2026
MAYA_SCRIPTS_DIR	:= $(MAYA_PREFS_DIR)/scripts
MAYA_WORKSPACES_DIR	:= $(MAYA_PREFS_DIR)/$(MAYA_VERSION)/prefs/workspaces

BACKUP_SUFFIX		:= .bak

hardlink			:= install -v -l h
symlink				:= install -v -l as

TARGETS				:= macos homebrew zsh bash starship git vim vscode \
						exiftool adobe capture_one maya

.PHONY: all $(TARGETS) clean

all: $(TARGETS)

# macOS ########################################################################

macos: $(XDG_STATE_HOME)/.macos_stamp

$(XDG_STATE_HOME)/.macos_stamp: ./macos.zsh | $(XDG_STATE_HOME)/.dirstamp
	"./$<"
	touch "$@"

# Homebrew #####################################################################

homebrew: $(XDG_STATE_HOME)/.homebrew_stamp

$(XDG_STATE_HOME)/.homebrew_stamp: Brewfile | $(XDG_STATE_HOME)/.dirstamp
	@if [[ -z $(shell command -v brew) ]]; then \
		eval $$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh); \
	fi
	@-brew bundle --verbose
	@touch "$@"

# Shells #######################################################################

zsh: $(HOME)/.zshenv $(ZDOTDIR)/.zprofile $(ZDOTDIR)/.zshrc

$(HOME)/.zshenv: Makefile
	@print -l -- "export XDG_CACHE_HOME='$(XDG_CACHE_HOME)'" \
		"export XDG_CONFIG_HOME='$(XDG_CONFIG_HOME)'" \
		"export XDG_BIN_HOME='$(XDG_BIN_HOME)'" \
		"export XDG_DATA_HOME='$(XDG_DATA_HOME)'" \
		"export XDG_STATE_HOME='$(XDG_STATE_HOME)'" \
		'' \
		"export ZDOTDIR='$(ZDOTDIR)'" >| "$@"
	@zcompile -U "$@"

$(ZDOTDIR)/.z%: ./Zsh/z% | $(ZDOTDIR)/.dirstamp
	@$(symlink) "$(abspath $<)" "$@"
	@zcompile -U "$@"

bash: $(HOME)/.bashrc

$(HOME)/.bashrc: ./Misc/bashrc
	@$(symlink) "$(abspath $<)" "$@"

starship: $(XDG_CONFIG_HOME)/starship.toml

$(XDG_CONFIG_HOME)/starship.toml: ./Misc/starship.toml
	$(symlink) "$(abspath $<)" "$@"

# Git ##########################################################################

git: $(HOME)/.gitconfig \
	$(GIT_CONFIGS_DIR)/.gitattributes $(GIT_CONFIGS_DIR)/.gitignore

$(HOME)/.gitconfig: ./Git/gitconfig Makefile
	sed -e 's|@@GIT_CONFIGS_DIR@@|$(abspath $(GIT_CONFIGS_DIR))|g' "$<" >| "$@"

$(GIT_CONFIGS_DIR)/.git%: ./Git/git% | $(GIT_CONFIGS_DIR)/.dirstamp
	@$(symlink) "$(abspath $<)" "$@"

# Editors ######################################################################

vim: $(HOME)/.vimrc

$(HOME)/.vimrc: ./Misc/vimrc
	@$(symlink) "$(abspath $<)" "$@"

vscode: $(VSCODE_PREFS_DIR)/settings.json $(VSCODE_PREFS_DIR)/tasks.json

$(VSCODE_PREFS_DIR)/%.json: ./VSCode/%.json | $(VSCODE_PREFS_DIR)/.dirstamp
	@$(symlink) "$(abspath $<)" "$@"

vscode-extensions: $(XDG_STATE_HOME)/.vscode_stamp

$(XDG_STATE_HOME)/.vscode_stamp: Brewfile
	@grep 'vscode' Brewfile | cut -d '"' -f 2 | \
		xargs -L 1 -P 0 code --force --install-extension
	@touch "$@"

# CLI Tools ####################################################################

exiftool: $(XDG_DATA_HOME)/ExifTool

$(XDG_DATA_HOME)/Exiftool: ./ExifTool
	@if [[ -e $@ && ! -h $@ ]]; then mv "$@" "$@$(BACKUP_SUFFIX)"; fi
	@$(symlink) "$(abspath $<)" "$@"

# Applications #################################################################

# TODO:
adobe:
	@cd ./Adobe; \
	for dir_name in CameraRaw Lightroom; do \
		target_dir=$(ADOBE_SUPPORT_DIR)/$${dir_name}; \
		for src in $${dir_name}/*; do \
			target="$${target_dir}/$${src:t}"; \
			if [[ ! -h "$$target" && -d "$$target" && $$(ls -A "$$target") ]]; then \
				mv "$$target" "$${target}$(BACKUP_SUFFIX)"; \
				echo "Backed up "$${target:t}" because it was not empty" 1>&2; \
			fi; \
 			$(symlink) "$$src" "$$target"; \
		done; \
	done

# TODO:
capture_one:
	@cd ./CaptureOne; \
	for src in Metadata/*.copreset(.N); do \
		$(hardlink) "$$src" $(C1_SUPPORT_DIR)/Presets60/$${src}; \
	done; \
	for src in Profiles/*.icc(.N); do \
		$(symlink) "$$src" "$(LIBRARY_DIR)/ColorSync/$${src}"; \
	done

maya: $(MAYA_PREFS_DIR)/$(MAYA_VERSION)/Maya.env \
	$(MAYA_WORKSPACES_DIR)/myRigging.json $(MAYA_SCRIPTS_DIR)/userSetup.py

$(MAYA_PREFS_DIR)/$(MAYA_VERSION)/Maya.env: ./Maya/Maya.env | \
		$(MAYA_PREFS_DIR)/$(MAYA_VERSION)/.dirstamp
	$(symlink) "$(abspath $<)" "$@"

$(MAYA_WORKSPACES_DIR)/myRigging.json: ./Maya/myRigging.json | \
		$(MAYA_WORKSPACES_DIR)/.dirstamp
	$(symlink) "$(abspath $<)" "$@"

$(MAYA_SCRIPTS_DIR)/userSetup.py: ./Maya/userSetup.py | \
		$(MAYA_SCRIPTS_DIR)/.dirstamp
	$(symlink) "$(abspath $<)" "$@"

# Directory Stamps #############################################################

%/.dirstamp:
	mkdir -p "$(@D)"
	@touch "$@"

# Cleanup ######################################################################

clean:
	-rm -f $(XDG_STATE_HOME)/.*_stamp
	-rm -f $(HOME)/.zshenv
	-rm -f $(HOME)/.gitconfig
	-find . -type f -name '*.dirstamp' -delete
