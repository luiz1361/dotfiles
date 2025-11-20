# Zsh completion for Terraform and Terragrunt
complete -C "$(command -v terraform)" terraform
complete -C "$(command -v terragrunt)" terragrunt

# Alias for running Terraform commands
alias tf="terraform"

# Alias for running Terragrunt commands
alias tg="terragrunt"

# Alias to run Terragrunt on all modules
alias tgr="tg run --all"
