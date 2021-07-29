#!/usr/bin/env python3
import re
import sys
import json
import time
import requests
import argparse
import subprocess
from random import randint

parser = argparse.ArgumentParser(description="Check for new versions of nuclei-templates")
parser.add_argument("file", help="Current version of nuclei-templates to check against")

args = parser.parse_args()
version_file = args.file

def main():
    r = requests.get("https://api.github.com/repos/projectdiscovery/nuclei-templates/releases/latest")

    json_data = json.loads(r.text)

    git_version = json_data["name"]

    with open(version_file, "r") as f:
        current_version = f.readline()

    if current_version.strip() != git_version:
        print("New version detected")
        print("Updating templates...")
        with open(version_file, "w") as f:
            f.write(git_version)

        time.sleep(randint(1, 30))
        output = subprocess.run("/root/certwatch/watcher.sh", check=True, text=True, shell=True, capture_output=True)

if __name__ == "__main__":
    main()
