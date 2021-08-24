# Subdomain enumeration
subfinder -dL /root/certwatch/domains-watcher.txt -all -o /root/certwatch/subfinder-uniqq.out

# Check for any new subdomains and save to not miss any new subdomains
sort -u /root/certwatch/subfinder-uniqq.out | uniqq --config /root/certwatch/config.yaml --subject "New subdomain(s) detected for 12:05 scan - $(cat /etc/hostname)" /root/certwatch/subfinder-watcher.txt | tee -a /root/certwatch/uniqq.txt

# Check for vulns using nuclei
nuclei -nt -severity critical,high,medium -o /root/certwatch/nuclei-uniqq.txt -l /root/certwatch/uniqq.txt

# Take screenshots
cat /root/certwatch/uniqq.txt | httpx -silent -ports 80,443 | aquatone -output /root/certwatch/aquatone/

# base64 encode images into HTML <img> tags
for img in $(ls /root/certwatch/aquatone/screenshots/*.png)
do
    echo $img | tee -a /root/certwatch/email.html
    echo "<img src=\"data:image/png;base64,$(cat $img | base64 -w 0)\"/>" | tee -a /root/certwatch/email.html
    echo "" | tee -a /root/certwatch/email.html
done

# Append nuclei results to email
echo "<h3>Nuclei scan results:</h3>" | tee -a /root/certwatch/email.html
cat /root/certwatch/nuclei-uniqq.txt | tee -a /root/certwatch/email.html

# Send screenshots via email
mail -s "$(echo -e "uniqq screenshots ready\nContent-Type: text/html")" mr.n30@protonmail.com < /root/certwatch/email.html

# Clean up
rm /root/certwatch/email.html
rm /root/certwatch/subfinder-uniqq.out
