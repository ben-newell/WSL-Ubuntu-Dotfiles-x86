#!/usr/bin/env bash
set -euo pipefail

# Basic dependencies
sudo apt update
sudo apt install -y build-essential curl file git

# Install Homebrew (Linuxbrew) for Linux/WSL
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set up Brew environment for current shell and future sessions
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
  if [[ -f "$HOME/.bash_profile" ]]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bash_profile"
  fi
elif [[ -d "$HOME/.linuxbrew" ]]; then
  eval "$HOME/.linuxbrew/bin/brew shellenv"
  echo 'eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"' >> "$HOME/.profile"
  if [[ -f "$HOME/.bash_profile" ]]; then
    echo 'eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"' >> "$HOME/.bash_profile"
  fi
fi

# Optional: verify installation
brew --version
echo "Homebrew installed and configured for WSL."

# Install requested tools (all via Homebrew)
brew install \
  dstat \
  direnv \
  pass \
  passage \
  screen \
  mpv \
  ffmpeg \
  pv \
  etckeeper \
  git \
  xkcdpass \
  ack \
  bat \
  exa \
  eza \
  lsd \
  git-delta \
  ncdu \
  dust \
  duf \
  broot \
  fd \
  ripgrep \
  the_silver_searcher \
  fzf \
  bfs \
  mcfly \
  choose-rust \
  jq \
  sd \
  bottom \
  glances \
  gtop \
  hyperfine \
  gping \
  procs \
  httpie \
  curlie \
  xh \
  zoxide \
  micro \
  nnn
