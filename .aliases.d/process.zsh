# psa: Alias for 'ps aux' to list all processes with detailed information
alias psa="ps aux"

# kj: Function to kill all background jobs by iterating through job IDs and sending kill signals
kj() {
    for job in `jobs -l | awk -F'[][]' '{print $2}'`; do
        kill %$job
    done
}
