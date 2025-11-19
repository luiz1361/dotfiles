# Use GNU sed (gsed) from Homebrew instead of the macOS BSD sed
alias sed="/opt/homebrew/bin/gsed"

# Use GNU awk (gawk) from Homebrew instead of the macOS mawk/awk
alias awk="/opt/homebrew/bin/gawk"

# Open Neovim (use Homebrew-installed nvim when running `v`)
alias v="/opt/homebrew/bin/nvim"

# Make `vim` launch Neovim (so calls to vim use nvim)
alias vim="nvim"

# Clean up Homebrew and macOS caches and perform maintenance
brewclean() {
    # Remove all immediate subdirectories inside ~/Library/Caches
    find ~/Library/Caches -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
    # Remove Homebrew's download/cache directory
    rm -rf "$(brew --cache)"
    # Update Homebrew, upgrade installed packages, remove outdated files and run diagnostics
    brew update && brew upgrade && brew cleanup -s && brew doctor
}
