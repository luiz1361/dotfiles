# Reload the Zsh configuration file by sourcing ~/.zshrc
alias reload="source ~/.zshrc"

# Benchmark Zsh startup time by running an interactive Zsh session 10 times and timing each one
alias zshbench="for i in {1..10}; do time zsh -i -c 'print -n'; done"
