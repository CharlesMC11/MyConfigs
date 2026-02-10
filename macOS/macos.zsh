#!/bin/zsh -f

sudo -v || exit 1
while true; do sudo -n true; sleep 60; kill -0 $$ || exit; done 2>/dev/null &

alias -g dw='defaults write'

################################################################################

killall 'System Settings' 2>/dev/null

# computer name ################################################################

sudo scutil --set ComputerName 'CharlesMC-Laptop'
sudo scutil --set HostName 'cmc-mbp.home.arpa'
sudo scutil --set LocalHostName 'cmc-mbp'

# Dock #########################################################################

alias dock='dw com.apple.dock'
dock autohide -bool true
dock largesize -int 48
dock launchanim -bool true
dock magnification -bool true
dock mineffect -string suck

dock autohide-delay -float 0
dock autohide-time-modifier -float 0.5

dock minimize-to-application -bool true
dock orientation -string left
dock show-process-indicators -bool true
dock show-recents -bool false

dock tilesize -int 32

dock windowtabbing -string always
dock enable-spring-load-actions-on-all-items -bool true
dock showhidden -bool true

# Finder #######################################################################

alias finder='dw com.apple.finder'
dw -g AppleShowAllExtensions -bool true
dw -g com.apple.springing.delay -float 1
dw -g NSToolbarTitleViewRolloverDelay -float 0
dw -g NSWindowResizeTime -float 0.001

dw -g NSNavPanelExpandedStateForSaveMode -bool true
dw -g NSNavPanelExpandedStateForSaveMode2 -bool true
dw -g PMPrintingExpandedStateForPrint -bool true
dw -g PMPrintingExpandedStateForPrint2 -bool true

finder _FXSortFoldersFirstOnDesktop -bool true
finder AppleShowAllFiles -bool false
finder FXRemoveOldTrashItems -bool true
finder ShowPathbar -bool true
finder ShowSidebar -bool true

# finder 'FXDefaultSearchScope' -string 'SCcf'
# finder 'FXPreferredGroupBy' -string Name

# finder 'FX_ArrangeBy' -string 'Kind'
# finder 'FXArrangeGroupViewBy' -string 'Name'

# finder '_FXSortFoldersFirst' -bool true

dw com.apple.desktopservices DSDontWriteNetworkStores -bool true
dw com.apple.desktopservices DSDontWriteUSBStores -bool true

chflags nohidden ~/Library

# Screencapture ################################################################

alias screencapture='dw com.apple.screencapture'
screencapture disable-shadow -bool true
screencapture show-thumbnail -bool false

# typing #######################################################################

dw -g NSAutomaticCapitalizationEnabled -bool false
dw -g NSAutomaticPeriodSubstitutionEnabled -bool false
dw -g NSAutomaticSpellingCorrectionEnabled -bool false

dw com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# mouse ########################################################################

dw -g com.apple.mouse.scaling -float 0.125
dw com.apple.Terminal FocusFollowsMouse -bool true

# networking ###################################################################

sudo sysctl -w net.inet.tcp.msl=15000
sudo sysctl -w net.inet.tcp.sendspace=262144
sudo sysctl -w net.inet.tcp.recvspace=262144

# system #######################################################################

dw com.apple.LaunchServices LSQuarantine -bool false
dw com.apple.CrashReporter DialogType -string 'developer'

killall Dock Finder SystemUIServer
