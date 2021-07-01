import re
import sys
import logging
import datetime
import certstream

# Regex
regex_start = "^[^*.](.*?)("
regex_finish = ")$"
all_words = ""

words = []

with open(sys.argv[1], 'r') as f:
    words = f.readlines()

# Concatenate words in file to form the final regex
for word in words:
    new_word = word.replace('.', "\.")
    all_words += f"\.{new_word.strip()}|"

# Final regex string
final_string = regex_start + all_words.strip(all_words[-1]) + regex_finish

regex = re.compile(final_string)

def print_callback(message, context):
    if message['message_type'] == "heartbeat":
        return

    if message['message_type'] == "certificate_update":
        all_domains = message['data']['leaf_cert']['all_domains']

        if len(all_domains) > 0:
            for domain in all_domains:
                try:
                    matches = re.match(regex, domain).group()

                    # Check if regex matches
                    if matches:
                        sys.stdout.write(f"{matches}\n")
                        sys.stdout.flush()

                        # Write results to a file
                        with open("/opt/tools/certwatch/new_domains.txt", "a+") as f:
                            f.write(f"{matches}\n")
                except:
                    pass

logging.basicConfig(format='[%(levelname)s:%(name)s] %(asctime)s - %(message)s', level=logging.INFO)

certstream.listen_for_events(print_callback, url='wss://certstream.calidog.io/')
