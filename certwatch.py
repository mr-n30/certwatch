import re
import os
import sys
import socket
import logging
import datetime
import argparse
import certstream

# Parse command line arguments
parser = argparse.ArgumentParser(description="Watch for new subdomains added to a target(s)")
parser.add_argument("-o", "--output", help="File to write the new subdomains to", required=True)
parser.add_argument("-d", "--domains", help="File containing a list of domains to watch for", required=True)

args        = parser.parse_args()
<<<<<<< HEAD
=======
config      = args.config
>>>>>>> bb919843841ae5790d5de4167c614bda5b75bdbe
domains     = args.domains
output_file = args.output

# Read domains from stdin
words = []
with open(domains, 'r') as f:
    words = f.readlines()

# Regex
regex_start = "^[^*.](.*?)("
regex_finish = ")$"
all_words = ""

# Create regex string
for word in words:
    new_word = word.replace('.', "\.")
    all_words += f"\.{new_word.strip()}|"

# Create regex final_string
final_string = regex_start + all_words.strip(all_words[-1]) + regex_finish
regex = re.compile(final_string)

# Hostname check
<<<<<<< HEAD
def check_if_hostname_is_valid(domain):
    try:
        ip = socket.gethostbyname(domain.strip())
        return 1
    except:
        return 0
=======
def check_if_hostname_is_valid(results):
    results_array = []

    for result in results:
        try:
            ip = socket.gethostbyname(result.strip())
            results_array.append(f"{result.strip()} - {ip}")
        except:
            pass

    return results_array

# Send email
def sendmail(results):
    with open(yaml_config, 'r') as f:
        yaml_data = yaml.safe_load(f)

    username  = yaml_data["username"][0]
    password  = yaml_data["password"][0]
    recipient = yaml_data["recipient"][0]

    msg = "Subject: New subdomain found! \n\n"

    final_results = []
    final_results = check_if_hostname_is_valid(results)

    if len(final_results) > 0:
        for result in final_results:
            msg = msg + result

        # Send the message
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as s:
            s.ehlo()
            s.login(username, password)
            s.sendmail(username, recipient, msg)

# Check for new changes/subdomains
def check_for_new_changes(matches):
    # Previouse file of domains
    b = []
    with open(output_file, "r") as f:
        b = f.readlines()

    # New file of domains
    a = []
    a.append(matches)

    final_results = list(set(a) - set(b))

    if len(final_results) > 0:
        sendmail(final_results)

        # Append new subdomains to previous file
        with open(output_file, "a+") as f:
            f.writelines(results)
>>>>>>> bb919843841ae5790d5de4167c614bda5b75bdbe

def print_callback(message, context):
    if message['message_type'] == "certificate_update":
        all_domains = message['data']['leaf_cert']['all_domains']

        if len(all_domains) > 0:
            for domain in all_domains:
                try:
                    # Check if regex matches
                    matches = re.match(regex, domain).group()

                    if matches:
                        valid_host_name = check_if_hostname_is_valid(matches)
                        if valid_host_name:
                            with open(output_file, "a+") as f:
                                f.write(f"{matches}\n")
                except:
                    pass

if __name__ == "__main__":
    logging.basicConfig(format='[%(levelname)s:%(name)s] %(asctime)s - %(message)s', level=logging.INFO)
    certstream.listen_for_events(print_callback, url='wss://certstream.calidog.io/')
