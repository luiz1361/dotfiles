# Initialize zoxide for zsh shell
eval "$(zoxide init zsh)"

# Zsh completion for AWS CLI
complete -C aws_completer aws

# Zsh completion for Terraform
complete -C "$(command -v terraform)" terraform

# Zsh completion for Terragrunt
complete -C "$(command -v terragrunt)" terragrunt

# Zsh completion for kraft
source ${HOME}/.zsh_kraft_completion;

# Zsh completion for kubectl
source <(kubectl completion zsh)

# Reload the Zsh configuration file by sourcing ~/.zshrc
alias reload="source ~/.zshrc"

# Benchmark Zsh startup time by running an interactive Zsh session 10 times and timing each one
alias zshbench="for i in {1..10}; do time zsh -i -c 'print -n'; done"
