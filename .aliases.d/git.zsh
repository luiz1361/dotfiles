# gs: Display a concise summary of the git repository status, showing the current branch, staged/unstaged changes, and untracked files.
alias gs="git status -sb"

# gmm: Fetch the main branch from origin and merge it into the current branch.
alias gmm="git fetch origin main:main && git merge main"

# gd: Show differences between the working directory and the index (staged changes).
alias gd="git diff"

# ga: Stage files for the next commit.
alias ga="git add"

# gc: Commit staged changes with a message.
alias gc="git commit -m "

# gr: Reset the index and working directory to the last commit (mixed reset by default).
alias gr="git reset"

# gf: Fetch updates from the remote repository without merging.
alias gf="git fetch"

# gb: List all branches in the repository.
alias gb="git branch"

# gbD: Force delete a branch.
alias gbD="git branch -D"

# gpull: Pull changes from the remote repository and merge them into the current branch.
alias gpull="git pull"

# gl: Display a graphical representation of the commit history in a compact format.
alias gl='git log --oneline --graph --all'

# gla: Display a detailed graphical log of all commits, including statistics and summaries.
alias gla='git log --stat --graph --summary --oneline --all'

# gpush: Push local commits to the remote repository.
alias gpush="git push"

# gcm: Switch to the main branch.
alias gcm="git checkout main"

# gcob: Create and switch to a new branch.
alias gcob="git checkout -b"

# gco: Switch to an existing branch or commit.
alias gco="git checkout"

# gclean: Show what would be removed by a clean operation without actually deleting files.
alias gclean="git clean -xdn"

# gcleanf: Forcefully remove untracked files and directories from the working directory.
alias gcleanf="git clean -xdf"

# gss: Display a concise summary of the git repository status, showing the current branch, staged/unstaged changes, and untracked files.
alias gss="git status -sb"

# gg: Display a graphical log of commits with decorations for branches and tags.
alias gg="git log --graph --oneline --decorate --all"

# gaa: Stage all changes in the working directory, including new, modified, and deleted files.
alias gaa="git add -A"

# gca: Commit all staged changes with a message.
alias gca="git commit -am"

# gbr: List all branches with verbose information, including tracking details.
alias gbr="git branch -avv"

# gprev: Switch back to the previously checked out branch.
alias gprev="git checkout -"

# gfa: Fetch updates from all remotes and prune deleted branches.
alias gfa="git fetch --all --prune"

# gup: Pull changes from the remote repository, rebasing local commits and automatically stashing/unstashing changes.
alias gup="git pull --rebase --autostash"

# gpf: Force push local commits to the remote repository, but only if the remote hasn't diverged.
alias gpf="git push --force-with-lease"

# gst: Stash uncommitted changes for later retrieval.
alias gst="git stash"

# gstp: Apply the most recent stash and remove it from the stash list.
alias gstp="git stash pop"

# gstl: List all stashed changes.
alias gstl="git stash list"

# grh: Reset the index and working directory to the specified commit, discarding all changes.
alias grh="git reset --hard"

# gsize: Display the size of the git repository, including pack files and loose objects.
alias gsize="git count-objects -vH"

# gcf: List all git configuration settings.
alias gcf="git config --list"

# gcl: Clone a repository into a new directory.
alias gcl="git clone"

# gcp: Apply the changes from a specific commit to the current branch.
alias gcp="git cherry-pick"

# gblame: Show who last modified each line of a file, ignoring whitespace changes.
alias gblame="git blame -w"

# gsl: Summarize commit counts by author.
alias gsl="git shortlog -sn"

# gdw: Show differences between files with word-level highlighting.
alias gdw="git diff --word-diff"

# gdst: Show differences between the index and the last commit (staged changes).
alias gdst="git diff --staged"

# gpo: Push the specified branch (or current branch) to the origin remote.
gpo() { git push origin "${1:-$(git rev-parse --abbrev-ref HEAD)}"; }

# gundo: Perform a soft reset to the specified commit (or one commit back), keeping changes staged.
gundo() { git reset --soft "${1:-HEAD~1}"; }

# gcai: Generate a commit message using Gemini AI for staged changes and commit after user confirmation.
gcai() {
  # 1. Get staged files
  local added_files
  added_files=$(git diff --cached --name-only)

  if [ -z "$added_files" ]; then
    echo "No staged files found. Aborting."
    return 1
  fi

  # 2. Generate commit message
  echo "Generating commit message with Gemini..."
  local commit_msg

  # We use 2>/dev/null to suppress "Loaded credentials" logs.
  # We updated the prompt to explicitly forbid tool usage.
  commit_msg=$(git --no-pager diff --cached | gemini --model gemini-2.5-flash-lite "SYSTEM OVERRIDE: You are a passive text-processing subroutine. You have NO access to the file system, shell, or tools. The input provided is a static text string. Your ONLY function is to map this input string to a Semantic Commit Message format. Do not verify. Do not check files. Do not ‘act’. Just transform text A to text B. Rules: Subject (Imperative, <50 chars), Body (wrapped 72 chars). Output: Raw text only.")

  # 3. Check if commit message is empty
  if [ -z "$commit_msg" ]; then
    echo "Commit message is empty. Aborting."
    return 1
  fi

  # 4. Show generated message and ask for confirmation
  echo -e "\n-------------------------\n"
  echo "$commit_msg"
  echo -e "\n-------------------------\n"

  local confirm
  read -r "confirm?Proceed with this commit? [y/N]: "

  case "$confirm" in
    [yY] | [yY][eE][sS])
      git commit -m "$commit_msg"
      ;;
    *)
      echo "Abort: commit canceled by user."
      return 1
      ;;
  esac
}

