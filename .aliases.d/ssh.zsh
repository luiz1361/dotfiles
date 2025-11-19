# Edit the system's hosts file using the default editor with sudo privileges
alias hosts='sudo $EDITOR /etc/hosts'

# Set up an SSH tunnel to forward local port 9090 to the remote Prometheus server on port 9090, connecting via port 29, and display the targets URL
alias rprom="ssh -N -L \*:9090:localhost:9090 remoteserver -p 29 &; echo http://localhost:9090/targets"
