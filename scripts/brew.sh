#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install Formulae
FORMULAE=(
  aarch64-elf-binutils
  aarch64-elf-gcc
  aom
  asciinema
  autoconf
  automake
  bash
  boost
  brotli
  ca-certificates
  cairo
  capstone
  catv
  coreutils
  ctags
  curl
  dav1d
  dbus
  double-conversion
  dtc
  fontconfig
  freetype
  fribidi
  gawk
  gd
  gettext
  gh
  glab
  glew
  glib
  gmp
  gnu-sed
  gnuplot
  gnupg
  gnutls
  graphitе2
  grep
  harfbuzz
  highway
  htop
  icu4c@77
  imath
  iperf3
  isl
  jansson
  jpeg-turbo
  jpeg-xl
  kraftkit
  krb5
  kubecolor
  libassuan
  libavif
  libb2
  libcbor
  libcerf
  libdeflate
  libevent
  libfido2
  libgcrypt
  libgpg-error
  libidn2
  libksba
  liblinear
  libmpc
  libnghttp2
  libnghttp3
  libngtcp2
  libpcap
  libpng
  libpq
  libslirp
  libssh
  libssh2
  libtasn1
  libtiff
  libtool
  libunistring
  libvmaf
  libx11
  libxau
  libxcb
  libxdmcp
  libxext
  libxrender
  libzip
  logstalgia
  lua
  make
  m4
  md4c
  moor
  mpdecimal
  mpfr
  ncurses
  nettle
  nmap
  npth
  ollama
  openexr
  openjph
  openssl@3
  p11-kit
  pango
  pcre2
  pgcli
  pinentry
  postgresql@14
  python@3.14
  qemu
  qt5compat
  qtbase
  qtdeclarative
  qtshadertools
  qtsvg
  readline
  redis
  rtmpdump
  screen
  socat
  sqlite
  tcpdump
  telnet
  thefuck
  tig
  tldr
  tree
  unbound
  vde
  webp
  wget
  x86_64-elf-binutils
  x86_64-elf-gcc
  xorgproto
  xz
  zlib
  zsh
  zstd
)

echo "Installing formulae..."
brew install "${FORMULAE[@]}"

# Install Casks
CASKS=(
  alt-tab
  hiddenbar
  ngrok
  rectangle
  iterm2
  vlc
  spotify
)

echo "Installing casks..."
brew install --cask "${CASKS[@]}"

echo "All packages installed successfully!"
