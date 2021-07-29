# Subdomain enumeration
subfinder -dL /root/certwatch/domains.txt -all -o /root/certwatch/subfinder-new.txt

# Check for any new subdomains
sort -u /root/certwatch/subfinder-new.txt | uniqq --config /root/certwatch/config.yaml --subject "New subdomain detected" /root/certwatch/subfinder.txt | tee -a /root/certwatch/uniqq.txt

# Check for open ports
httpx -ports 80,443,8080,8081,8443 -o /root/certwatch/httpx.txt < /root/certwatch/uniqq.txt

# Scan for vulns
nuclei -ut
nuclei -t /root/nuclei-templates/ -severity critical,high,medium -o /root/certwatch/nuclei.txt -l /root/certwatch/httpx.txt

# Send email of nuclei.txt
mail -s "nuclei scan finished with $(wc --lines /root/certwatch/nuclei.txt | grep -oE '[0-9]+') lines" mr.n30@protonmail.com < /root/certwatch/nuclei.txt

# Clean up
rm /root/certwatch/subfinder-new.txt

# Uncomment this if you want to remove the new domains
#rm /root/certwatch/uniqq.txt

rm /root/certwatch/httpx.txt
rm /root/certwatch/nuclei.txt
