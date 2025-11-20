# psa: Alias for 'ps aux' to list all processes with detailed information
alias psa="ps aux"

# topp: Alias for 'btm -r 250' to run bottom with a refresh rate of 250 milliseconds in tree view
alias topp="btm -r 250 --tree"

# kj: Function to kill all background jobs by iterating through job IDs and sending kill signals
kj() {
    for job in `jobs -l | awk -F'[][]' '{print $2}'`; do
        kill %$job
    done
}
