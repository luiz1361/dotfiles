#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

SCRIPT_DIR="$(dirname "$0")"
DATA_DIR="data"
FORMULAE_FILE="$SCRIPT_DIR/$DATA_DIR/brew-formulae.txt"
CASKS_FILE="$SCRIPT_DIR/$DATA_DIR/brew-casks.txt"
TAPS_FILE="$SCRIPT_DIR/$DATA_DIR/brew-taps.txt"

show_help() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  backup   Backup currently installed Homebrew formulae and casks to brew-formulae.txt and brew-casks.txt
  install  Install formulae and casks from brew-formulae.txt and brew-casks.txt
  upgrade  Update Homebrew and Upgrade installed packages
  help     Show this help message
EOF
}

case "$1" in
  backup)
  echo "Backing up installed Homebrew formulae to $FORMULAE_FILE..."
  brew list --formula --full-name > "$FORMULAE_FILE"
  echo "Backing up installed Homebrew casks to $CASKS_FILE..."
  brew list --cask --full-name > "$CASKS_FILE"
  echo "Backing up required Homebrew taps to $TAPS_FILE..."
  # Extract taps from full names (format: tap/name), filter valid taps (must be user/repo)
  TAPS=$(cat "$FORMULAE_FILE" "$CASKS_FILE" | grep -E '^[^/]+/[^/]+/' | sed 's|/.*||' | sort -u)
  # Also include currently tapped taps (for completeness), but only valid ones
  TAPS_ALL=$( (brew tap | grep -E '^[^/]+/[^/]+$' | sort -u; echo "$TAPS") | grep -E '^[^/]+/[^/]+$' | sort -u )
  printf "%s\n" $TAPS_ALL > "$TAPS_FILE"
  echo "Backup complete."
    ;;
  install)
    if [[ ! -f "$FORMULAE_FILE" ]]; then
      echo "Formulae file not found: $FORMULAE_FILE"
      exit 1
    fi
    if [[ ! -f "$CASKS_FILE" ]]; then
      echo "Casks file not found: $CASKS_FILE"
      exit 1
    fi
    if [[ -f "$TAPS_FILE" ]]; then
      mapfile -t TAPS < <(grep -v '^#' "$TAPS_FILE" | grep -v '^$')
      if [[ ${#TAPS[@]} -gt 0 ]]; then
        echo "Tapping required Homebrew taps..."
        for tap in "${TAPS[@]}"; do
          brew tap "$tap" || true
        done
      fi
    fi
    mapfile -t FORMULAE < <(grep -v '^#' "$FORMULAE_FILE" | grep -v '^$')
    mapfile -t CASKS < <(grep -v '^#' "$CASKS_FILE" | grep -v '^$')
    echo "Installing formulae from $FORMULAE_FILE..."
    if [[ ${#FORMULAE[@]} -gt 0 ]]; then
      for formula in "${FORMULAE[@]}"; do
        echo "Installing $formula..."
        brew install "$formula"
      done
    else
      echo "No formulae to install."
    fi
    echo "Installing casks from $CASKS_FILE..."
    if [[ ${#CASKS[@]} -gt 0 ]]; then
      for cask in "${CASKS[@]}"; do
        echo "Installing $cask..."
        brew install --cask "$cask"
      done
    else
      echo "No casks to install."
    fi
    echo "All packages installed successfully!"
    ;;
  upgrade)
    echo "Updating Homebrew..."
    brew update
    echo "Upgrading Homebrew..."
    brew upgrade
    ;;
  help|--help|-h)
    show_help
    ;;
  "")
    show_help
    ;;
  *)
    echo "Unknown command: $1"
    show_help
    exit 1
    ;;
esac
