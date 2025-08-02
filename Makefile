LIBRARY_DIR      := $(HOME)/Library
APP_SUPPORT_DIR  := $(LIBRARY_DIR)/Application Support

LOCAL_CONFIG_DIR := $(HOME)/.config

hardlink         := install -v -l h
symlink          := install -v -l as

PHONIES          := adobe capture_one exiftool git maya misc vscode zsh
.PHONY: $(PHONIES)


all: macos homebrew $(PHONIES)


adobe:
	cd ./$@;\
	for dir_name in CameraRaw Lightroom; do\
		target_dir="$(APP_SUPPORT_DIR)/Adobe/$${dir_name}";\
		for src in $${dir_name}/*; do\
			target="$${target_dir}/$$(basename "$$src")";\
			if [ ! -h "$$target" ] && [ -d "$$target" ] && [ $$(ls -A "$$target") ]; then\
				mv "$$target" "$${target}.bak";\
				echo "Backed up $$(basename "$$target") because it was not empty" 1>&2;\
			fi;\
 			$(symlink) "$$src" "$$target";\
		done;\
	done


capture_one:
	cd ./$@;\
	for src in Metadata/*.copreset; do\
		$(hardlink) "$$src" "$(APP_SUPPORT_DIR)/Capture One/Presets60/$$src";\
	done;\
	for src in Profiles/*.icc; do\
		$(symlink) "$$src" "$(LIBRARY_DIR)/ColorSync/$$src";\
	done


exiftool:
	for file in ./$@/*.args; do\
		$(symlink) $$file $(LOCAL_CONFIG_DIR)/$@;\
	done


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


macos: macos.sh
	./$<


MAYA_YEAR := 2025
MAYA_DIR  := $(LIBRARY_DIR)/Preferences/Autodesk/maya
maya: maya/Maya.env maya/myRigging.json maya/userSetup.py
	cd ./$@;\
	$(symlink) Maya.env       $(MAYA_DIR)/$(MAYA_YEAR);\
	$(symlink) myRigging.json $(MAYA_DIR)/$(MAYA_YEAR)/prefs/workspaces/myRigging.json;\
	$(symlink) userSetup.py   $(MAYA_DIR)/scripts


misc: misc/.bashrc misc/.vimrc
	for src in $^; do\
		$(symlink) $$src ~;\
	done


vscode: vscode/settings.json vscode/tasks.json
	for src in $^; do\
		$(symlink) $$src "$(APP_SUPPORT_DIR)/Code/User/$$(basename $$src)";\
	done


zsh: zsh/.zprofile zsh/.zshenv zsh/.zshrc zsh/spaceship.zsh
	for src in $^; do zsh -c "zcompile $$src"; done

	cd ./$@;\
	$(symlink) .zshenv           ~;\
	$(symlink) .zshenv.zwc       ~;\
	$(symlink) .zprofile         $(LOCAL_CONFIG_DIR)/zsh;\
	$(symlink) .zprofile.zwc     $(LOCAL_CONFIG_DIR)/zsh;\
	$(symlink) .zshrc            $(LOCAL_CONFIG_DIR)/zsh;\
	$(symlink) .zshrc.zwc        $(LOCAL_CONFIG_DIR)/zsh;\
	$(symlink) spaceship.zsh     $(LOCAL_CONFIG_DIR)
	$(symlink) spaceship.zsh.zwc $(LOCAL_CONFIG_DIR)
