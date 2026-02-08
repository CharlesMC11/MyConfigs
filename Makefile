SHELL				:= $(shell which zsh)

LIBRARY_DIR			:= $(HOME)/Library
APP_SUPPORT_DIR		:= $(LIBRARY_DIR)/Application Support

XDG_CACHE_HOME		:= $(HOME)/.cache
XDG_CONFIG_HOME		:= $(HOME)/.config
XDG_BIN_HOME		:= $(HOME)/.local/bin
XDG_DATA_HOME		:= $(HOME)/.local/share
XDG_STATE_HOME		:= $(HOME)/.local/state

ZDOTDIR				:= $(XDG_CONFIG_HOME)/zsh

GIT_CONFIGS_DIR		:= $(XDG_CONFIG_HOME)/git

VSCODE_PREFS_DIR	:= $(APP_SUPPORT_DIR)/Code/User

MAYA_PREFS_DIR		:= $(LIBRARY_DIR)/Preferences/Autodesk/maya
MAYA_VERSION		:= 2026
MAYA_SCRIPTS_DIR	:= $(MAYA_PREFS_DIR)/scripts
MAYA_WORKSPACES_DIR	:= $(MAYA_PREFS_DIR)/$(MAYA_VERSION)/prefs/workspaces

BACKUP_SUFFIX		:= .bak

hardlink			:= install -v -l h
symlink				:= install -v -l as

PHONIES				:= adobe capture_one exiftool git maya misc vscode zsh
.PHONY: $(PHONIES)


all: macos homebrew $(PHONIES)


adobe:
	cd ./$@;\
	for dir_name in CameraRaw Lightroom; do\
		target_dir="$(APP_SUPPORT_DIR)/Adobe/$${dir_name}";\
		for src in $${dir_name}/*; do\
			target="$${target_dir}/$${src:t}";\
			if [[ ! -h "$$target" && -d "$$target" && $$(ls -A "$$target") ]]; then\
				mv "$$target" "$${target}.bak";\
				echo "Backed up "$${target:t}" because it was not empty" 1>&2;\
			fi;\
 			$(symlink) "$$src" "$$target";\
		done;\
	done


capture_one:
	cd ./$@;\
	for src in Metadata/*.copreset(N); do\
		$(hardlink) "$$src" "$(APP_SUPPORT_DIR)/Capture One/Presets60/$${src}";\
	done;\
	for src in Profiles/*.icc(N); do\
		$(symlink) "$$src" "$(LIBRARY_DIR)/ColorSync/$${src}";\
	done


exiftool:
	if [[ -e ~/.local/share/$@ && ! -h ~/.local/share/$@ ]]; then\
		mv ~/.local/share/$@ ~/.local/share/$@~;\
	fi
	$(symlink) $@ ~/.local/share/$@


git: git/.gitattributes git/.gitconfig git/.gitignore
	cd ./$@;\
	$(symlink) ./.gitconfig     ~;\
	$(symlink) ./.gitattributes $(LOCAL_CONFIG_DIR)/$@;\
	$(symlink) ./.gitignore     $(LOCAL_CONFIG_DIR)/$@


homebrew: Brewfile
	if [[ ! -x /opt/homebrew/brew ]]; then\
		eval $$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh);\
	fi
	brew bundle


macos: macos.zsh
	./$<


MAYA_YEAR := 2026
MAYA_DIR  := $(LIBRARY_DIR)/Preferences/Autodesk/maya
maya: maya/Maya.env maya/myRigging.json maya/userSetup.py
	cd ./$@;\
	$(symlink) Maya.env       $(MAYA_DIR)/$(MAYA_YEAR);\
	$(symlink) myRigging.json $(MAYA_DIR)/$(MAYA_YEAR)/prefs/workspaces/myRigging.json;\
	$(symlink) userSetup.py   $(MAYA_DIR)/scripts


misc: misc/.bashrc misc/.vimrc misc/starship.toml
	for src in $^; do\
		$(symlink) $$src ~;\
	done


vscode: vscode/settings.json vscode/tasks.json
	for src in $^; do\
		$(symlink) $$src "$(APP_SUPPORT_DIR)/Code/User/$${src:t}";\
	done


zsh: zsh/.zprofile zsh/.zshenv zsh/.zshrc misc/starship.toml
	for src in $^; do zcompile "$$src"; done

	cd ./$@;\
	$(symlink) .zshenv           ~;\
	$(symlink) .zshenv.zwc       ~;\
	$(symlink) .zprofile         $(LOCAL_CONFIG_DIR)/zsh;\
	$(symlink) .zprofile.zwc     $(LOCAL_CONFIG_DIR)/zsh;\
	$(symlink) .zshrc            $(LOCAL_CONFIG_DIR)/zsh;\
	$(symlink) .zshrc.zwc        $(LOCAL_CONFIG_DIR)/zsh
