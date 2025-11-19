# Start a Ruby HTTP server in the current directory on port 8000
alias server_ruby='ruby -run -e httpd . -p 8000'

# Start a Python HTTP server in the current directory on port 4445
alias server_python='python -m http.server 4445'

# Expose a local HTTP server to the internet using ngrok (requires ngrok to be installed and authenticated)
alias expose="ngrok http"
