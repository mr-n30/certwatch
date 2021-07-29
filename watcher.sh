# Subdomain enumeration
subfinder -dL /root/certwatch/domains-watcher.txt -all -o /root/certwatch/subfinder-watcher.out

# Check for any new subdomains and save to not miss any subdomains
sort -u /root/certwatch/subfinder-watcher.out | uniqq --config /root/certwatch/config.yaml --subject "New subdomain detected for nuclei updates" /root/certwatch/subfinder-watcher.txt | tee -a /root/certwatch/uniqq.txt

# Check for open ports
httpx -ports 80,443,8080,8081,8443 -o /root/certwatch/httpx-watcher.txt < /root/certwatch/subfinder-watcher.txt

# Update nuclei and scan for vulns
nuclei -ut
nuclei -t /root/nuclei-templates/ -severity critical,high,medium -o /root/certwatch/nuclei-watcher.txt -l /root/certwatch/httpx-watcher.txt

# Send email of nuclei.txt
mail -s "nuclei update detected. finished with $(wc --lines /root/certwatch/nuclei-watcher.txt | grep -oE '[0-9]+') lines" mr.n30@protonmail.com < /root/certwatch/nuclei-watcher.txt

# Clean up
rm /root/certwatch/subfinder-watcher.out
rm /root/certwatch/httpx-watcher.txt
