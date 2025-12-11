#!/bin/sh

# somewhat vibed pkgs script

set -e

BREW="/opt/homebrew/bin/brew"

step_homebrew() {
  [ -f "$BREW" ] && return
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

step_packages() {
  eval "$($BREW shellenv)"

  brew tap nikitabobko/tap || true
  brew tap FelixKratz/formulae || true

  brew install tmux neovim kitty asdf macism aerospace jankyborders

  [ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

step_start_services() {
  eval "$($BREW shellenv)"
  brew services start jankyborders || true
}

step_asdf() {
  eval "$($BREW shellenv)"
  . /opt/homebrew/opt/asdf/libexec/asdf.sh

  asdf plugin add golang  || true
  asdf plugin add python  || true
  asdf plugin add nodejs  || true

  GO_VER=$(asdf latest golang)
  PY_VER=$(asdf latest python)
  NODE_VER=$(asdf latest nodejs)

  asdf install golang "$GO_VER"
  asdf set -u golang "$GO_VER"

  asdf install python "$PY_VER"
  asdf set -u python "$PY_VER"

  asdf install nodejs "$NODE_VER"
  asdf set -u nodejs "$NODE_VER"

  asdf reshim
}

step_go_tools() {
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
  go install github.com/junikimm717/tmuxs@latest
  asdf reshim golang
}

step_capslock() {
  hidutil property --set '{
    "UserKeyMapping":[
      {"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}
    ]
  }'

  mkdir -p ~/Library/LaunchAgents

  cat > ~/Library/LaunchAgents/local.remap.capslock.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
 <dict>
  <key>Label</key><string>local.remap.capslock</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/hidutil</string>
    <string>property</string>
    <string>--set</string>
    <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}</string>
  </array>
  <key>RunAtLoad</key><true/>
 </dict>
</plist>
EOF

  launchctl load ~/Library/LaunchAgents/local.remap.capslock.plist || true
}

step_ssh() {
  mkdir -p ~/.ssh
  KEY=~/.ssh/id_ed25519
  [ -f "$KEY" ] || ssh-keygen -t ed25519 -f "$KEY" -N ""

  CONFIG=~/.ssh/config
  touch "$CONFIG"

  if ! grep -q "^Host github.com" "$CONFIG"; then
    cat >> "$CONFIG" <<EOF

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
EOF
  fi

  pbcopy < ~/.ssh/id_ed25519.pub

  chmod 600 ~/.ssh/*
}

############################################################
# Select which steps run
############################################################

step_homebrew
step_packages
step_start_services
step_asdf
step_go_tools
step_capslock
step_ssh

echo "Bootstrap completed."
