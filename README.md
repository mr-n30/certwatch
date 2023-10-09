# certwatch
**Important**: Before running `watcher.sh` you must run the initial subdomain scan e.g:
```bash
subfinder -dL /root/certwatch/domains-watcher.txt -all -o /root/certwatch/subfinder-watcher.txt
```


Otherwise you'll receive Python subprocess errors in our email via crontab

# TODO
- Check this code and see if it's still working refactor if needed
