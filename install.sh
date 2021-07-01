#!/usr/bin/env bash
# Adapted from https://github.com/nicknisi/dotfiles

COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

setup_links() {
  title "Creating symlinks"

  linkables=$( find -H "$(pwd)" -maxdepth 3 -name '*.lnk' )
  for file in $linkables ; do
    target="$HOME/.$( basename "$file" ".lnk" )"

    if [ -f "$target" ]; then
      mv "${target}" "${target}.bkp"
    fi

    info "creating symlink for $file"
    ln -s "${file}" "${target}"
  done
  echo
}

setup_homebrew() {
  title "Setting up Homebrew"

  if test ! "$(command -v brew)"; then
      info "Homebrew not installed. Installing."
      # Run as a login shell (non-interactive) so that the script doesn't pause for user input
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
  fi

  if [ "$(uname)" == "Linux" ]; then
      test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
      test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      # Step moved to bash_profile
      # test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  fi

  # install brew dependencies from Brewfile
  brew bundle

}

setup_os(){
  setup_linux
  setup_macos
}

setup_linux(){
  title "Configuring Linux"
  if [[ "$(uname)" == "Linux" ]]; then

    echo "Update repos"
    sudo apt update

    echo "Install base packages"
    sudo apt install -y --no-install-recommends \
      build-essential \
      curl \
      docker.io \
      fonts-hack-ttf \
      geary \
      git \
      gnome-calendar \
      nautilus-dropbox \
      network-manager-l2tp-gnome \
      python3 \
      python3-pip \
      python-is-python3 \
      stacer

    echo "Install snap packages"
    sudo snap install slack --classic
    sudo snap install code --classic
    sudo snap install \
      spotify \
      evernote-web-client \
      drawio \
      google-chat-electron \
      teams-for-linux

    echo "Add user to docker group"
    if ! groups "$USER" | grep -q docker; then
      sudo groupadd docker
      sudo usermod -aG docker "$USER"
      newgrp docker
    fi

    echo "Autoremove no longer needed packages"
    sudo apt autoremove -y

    echo "Add auto-upgrade crontabs"
    cat << EOF | crontab
0 11 * * * root apt update && apt upgrade -y && apt autoremove && apt autoclean
0 11 * * * $USER brew update && brew upgrade^C
EOF
    crontab -l

  else
    warning "Linux not detected. Skipping."
  fi
}

setup_macos() {
  title "Configuring macOS"
  if [[ "$(uname)" == "Darwin" ]]; then

    echo "Finder: show all filename extensions"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    echo "show hidden files by default"
    defaults write com.apple.Finder AppleShowAllFiles -bool false

    echo "only use UTF-8 in Terminal.app"
    defaults write com.apple.terminal StringEncodings -array 4

    echo "expand save dialog by default"
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

    echo "show the ~/Library folder in Finder"
    chflags nohidden ~/Library

    echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    echo "Enable subpixel font rendering on non-Apple LCDs"
    defaults write NSGlobalDomain AppleFontSmoothing -int 2

    echo "Use current directory as default search scope in Finder"
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    echo "Show Path bar in Finder"
    defaults write com.apple.finder ShowPathbar -bool true

    echo "Show Status bar in Finder"
    defaults write com.apple.finder ShowStatusBar -bool true

    echo "Disable press-and-hold for keys in favor of key repeat"
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    echo "Set a blazingly fast keyboard repeat rate"
    defaults write NSGlobalDomain KeyRepeat -int 1

    echo "Set a shorter Delay until key repeat"
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    echo "Enable tap to click (Trackpad)"
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    echo "Import iTerm2 plist"
    echo iterm2/plist.xml | defaults import com.googlecode.iterm2 -

    echo "Kill affected applications"

    for app in Safari Finder Dock Mail SystemUIServer iTerm; do killall "$app" >/dev/null 2>&1; done

  else
    warning "macOS not detected. Skipping."
  fi
}

setup_links
setup_os
setup_homebrew
