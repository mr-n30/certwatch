# Required for cronjobs to work
# Other scripts (watcher.sh and uniqq.sh) rely on these output files before working correctly
# tmux new-session -d "ls -lah"
subfinder -dL /root/certwatch/domains-watcher.txt -all -o /root/certwatch/subfinder-watcher.txt
subfinder -dL /root/certwatch/domains-wildcard.txt -all -o /root/certwatch/subfinder-wildcard.txt

