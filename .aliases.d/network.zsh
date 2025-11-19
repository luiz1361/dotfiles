# Get external IP address in JSON format (or use /ip for plain-text IP)
alias myip="curl https://ipinfo.io/json"

# Run an internet speed test using the speedtest-cli script downloaded from GitHub
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

# Perform an Nmap scan with default scripts, version detection, and output to a file named 'nmap'
alias nm="nmap -sC -sV -oN nmap"
