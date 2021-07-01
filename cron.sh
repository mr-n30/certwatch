# Check for new domains that are added
sort -u /opt/tools/certwatch/new_domains.txt | uniqq --config /opt/p/config/email_login.yaml --email mr.n30@protonmail.com /opt/tools/certwatch/new_domains_sorted.txt
