#!/usr/bin/env sh

sudo -v || exit 1

alias dw='sudo defaults write'

################################################################################

killall 'System Settings' 2>/dev/null


# computer name
readonly computer_name=CMC-MBP
for name in ComputerName HostName LocalHostName; do
    sudo scutil --set "$name" "$computer_name"
done
dw /Library/Preferences/SystemConfiguration/com.apple.smb.server\
    NetBIOSName -string "$computer_name"


# dock
alias dock='dw com.apple.dock'
dock autohide -bool true
dock autohide-immutable -bool true

dock largesize -int 48
dock launchanim -bool true
dock launchanim-immutable -bool true

dock magnification -bool true
dock magnify-immutable -bool true
dock magsize-immutable -bool true

dock mineffect -string suck
dock mineffect-immutable -bool true

dock autohide-delay -float 0
dock autohide-time-modifier -float 0.5

dock minimize-to-application -bool true
dock minintoapp-immutable -bool true

dock orientation -string left
dock position-immutable -bool true

dock show-process-indicators -bool true
dock showindicators-immutable -bool true

dock show-recents -bool false
dock showrecents-immutable -bool true

dock size-immutable -bool true
dock tilesize -int 32

dock windowtabbing -string always
dock windowtabbing-immutable -bool true

dock enable-spring-load-actions-on-all-items -bool true
dock showhidden -bool true


# finder
alias finder='dw com.apple.finder'
dw -g AppleShowAllExtensions -bool true
dw -g com.apple.springing.delay -float 1
dw -g NSToolbarTitleViewRolloverDelay -float 0
finder AppleShowAllFiles -bool false
# finder 'FXDefaultSearchScope' -string 'SCcf'
# finder 'FXPreferredGroupBy' -string Name
finder FXRemoveOldTrashItems -bool true
finder ShowPathbar -bool true

# finder 'FX_ArrangeBy' -string 'Kind'
# finder 'FXArrangeGroupViewBy' -string 'Name'

# finder '_FXSortFoldersFirst' -bool true
finder _FXSortFoldersFirstOnDesktop -bool true
finder ShowSidebar -bool true


# screenshots
alias screencapture='dw com.apple.screencapture'
screencapture disable-shadow -bool true
screencapture show-thumbnail -bool false

dir=~/MyFiles/Pictures/Screenshots/.tmp
mkdir "$dir" 2>/dev/null
screencapture location -string "$dir"


# globals
dw com.apple.SoftwareUpdate ScheduleFrequency -int 1
# nvram good-samaritan-message="Aren't you a little nosy, hm?"


# typing
dw -g NSAutomaticCapitalizationEnabled -bool false
dw -g NSAutomaticPreiodSubstitutionEndabled -bool false
dw -g NSAutomaticSpellingCorrectionEnabled -bool false


# mouse
dw -g com.apple.mouse.scaling -float 0.125
dw com.apple.Terminal FocusFollowsMouse -bool true


killall Dock Finder SystemUIServer
