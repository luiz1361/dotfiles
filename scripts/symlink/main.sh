

#!/bin/bash

# Exit immediately if a command fails
set -e

# Argument parsing using case statement (only $1)
FORCE_MODE=false
DRY_RUN=false
case "$1" in
	"--force")
		FORCE_MODE=true
		;;
	"--dry-run")
		DRY_RUN=true
		;;
	"" )
		# No argument, do nothing
		;;
	"--help"|"-h")
		echo "Usage: $0 [--force|--dry-run]"
		echo "  --force    Remove and replace existing files/symlinks."
		echo "  --dry-run  Show what would be done, but make no changes."
		echo "  --help     Show this help message."
		exit 0
		;;
	*)
		echo "Unknown argument: $1" >&2
		echo "Usage: $0 [--force|--dry-run]"
		echo "  --force    Remove and replace existing files/symlinks."
		echo "  --dry-run  Show what would be done, but make no changes."
		echo "  --help     Show this help message."
		exit 1
		;;
esac

# Base directory where dotfiles are stored
DOTFILES_DIR="$HOME/dotfiles"

# List of symlinks: (target relative to ~) (source relative to $DOTFILES_DIR)
# Use parallel arrays for compatibility with old bash versions
SYMLINK_TARGETS=(
	".config/eza/theme.yml"
	".config/gh"
	".config/mise/config.toml"
	".config/nvim"
	".config/starship.toml"
	".config/yazi"
	".curlrc"
	".editorconfig"
	".gitconfig"
	".gitignore"
	".gitleaks.toml"
	".gitmessage"
	".hushlogin"
	".inputrc"
	".lefthook.yml"
	".mackup.cfg"
	".rspec"
	".screenrc"
	".ssh/config"
	".tmux.conf"
	".tmux.conf.local"
	".wgetrc"
	".zshrc"
	"ansible.cfg"
	"dialogrc"
	"Library/Application Support/Code/User/prompts/copilot.instructions.md"
	".aliases.d"
	"Library/Application Support/Code/User/settings.json"
)
SYMLINK_SOURCES=(
	".config/eza/theme.yml"
	".config/gh"
	".config/mise/config.toml"
	".config/nvim"
	".config/starship.toml"
	".config/yazi"
	".curlrc"
	".editorconfig"
	".gitconfig"
	".gitignore"
	".gitleaks.toml"
	".gitmessage"
	".hushlogin"
	".inputrc"
	".lefthook.yml"
	".mackup.cfg"
	".rspec"
	".screenrc"
	".ssh/config"
	".tmux.conf"
	".tmux.conf.local"
	".wgetrc"
	".zshrc"
	"ansible.cfg"
	"dialogrc"
	".github/copilot.instructions.md"
	".aliases.d"
	".vscode/settings.json"
)

# Function to create symlink with backup and options
symlink_with_backup() {
	local rel_target_path="$1"
	local rel_source_path="$2"
	local abs_target_path="$HOME/$rel_target_path"
	local abs_source_path="$DOTFILES_DIR/$rel_source_path"

	# Print what will be done
  echo "\nProcessing symlink:"
	echo "Source: $abs_source_path"
  echo "Target: $abs_target_path"

	# Create parent directory for target if it does not exist
	parent_dir="$(dirname "$abs_target_path")"
	if [ ! -d "$parent_dir" ]; then
		if [ "$DRY_RUN" = false ]; then
			mkdir -p "$parent_dir"
			echo "Created parent directory: $parent_dir"
		else
			echo "[DRY RUN] Would create parent directory: $parent_dir"
		fi
	fi

  # Check if target exists
	current_link=""
	exists=0
	if [ -L "$abs_target_path" ]; then
		current_link="$(readlink "$abs_target_path")"
		exists=1
	elif [ -e "$abs_target_path" ]; then
		exists=1
	fi

	if [ $exists -eq 1 ]; then
		if [ -L "$abs_target_path" ] && [ "$current_link" = "$abs_source_path" ]; then
			echo "$abs_target_path already correctly points to $abs_source_path, nothing to do."
			return
		fi
		# Exists but is not the correct symlink
		if [ "$FORCE_MODE" = true ]; then
			mv "$abs_target_path" "$abs_target_path.bak.$(date +%s)"
			echo "[FORCE] Moved existing $abs_target_path to $abs_target_path.bak.$(date +%s)"
			ln -sf "$abs_source_path" "$abs_target_path"
			echo "Linked $abs_target_path -> $abs_source_path"
		elif [ "$DRY_RUN" = true ]; then
			if [ -n "$current_link" ]; then
				echo "[DRY RUN] CUR $abs_target_path > $current_link"
			fi
			echo "[DRY RUN] BAK $abs_target_path -> $abs_target_path.bak.$(date +%s)"
			echo "[DRY RUN] NEW $abs_target_path -> $abs_source_path"
		else
			echo "Error: $abs_target_path exists and is not the correct symlink. Use --force to override or remove it." >&2
			exit 1
		fi
	else
		# Target does not exist
		if [ "$DRY_RUN" = true ]; then
			echo "[DRY RUN] NEW $abs_target_path -> $abs_source_path"
		else
			ln -sf "$abs_source_path" "$abs_target_path"
			echo "Linked $abs_target_path -> $abs_source_path"
		fi
	fi
}

# Main loop (old bash compatible)
count=${#SYMLINK_TARGETS[@]}
i=0
while [ $i -lt $count ]; do
	rel_target_path="${SYMLINK_TARGETS[$i]}"
	rel_source_path="${SYMLINK_SOURCES[$i]}"
	symlink_with_backup "$rel_target_path" "$rel_source_path"
	i=$((i + 1))
done

