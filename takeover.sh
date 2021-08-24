# Scan for subdomain takeover's
nuclei -t /root/nuclei-templates/takeovers/ -o /root/certwatch/nuclei.txt -l /root/certwatch/httpx.txt

# Send email of nuclei.txt
if [ -s /root/certwatch/nuclei.txt ]
then
    mail -s "Subdomain takeover scan finished with $(wc --lines /root/certwatch/nuclei.txt | grep -oE '[0-9]+') lines" mr.n30@protonmail.com < /root/certwatch/nuclei.txt
fi
