import os
import re
import requests
import subprocess
from pathlib import Path
from xml.etree import ElementTree


def get_latest_version() -> str:
    resp = requests.get("https://pypi.org/rss/project/yt-dlp/releases.xml")
    resp.raise_for_status()
    rss = ElementTree.fromstring(resp.text)
    channel = rss.findall('channel')[0]
    versions = [v.find("title").text for v in channel.findall('item')]
    versions = [v for v in versions if not v.endswith(".dev0")]
    return versions[0]


def get_current_version() -> str:
    for line in Path("Dockerfile").read_text().splitlines():
        m = re.search(r"yt-dlp==(\d+\.\d+\.\d+)", line)
        if m is not None:
            return m.group(1)


def set_version(version: str):
    lines = Path("Dockerfile").read_text().splitlines()
    new_lines = [re.sub(r"yt-dlp==(\d+\.\d+\.\d+)", f"yt-dlp=={version}", line) for line in lines]
    Path("Dockerfile").write_text("\n".join(new_lines) + "\n")


def pad_version(version: str):
    year, month, day = [int(x) for x in version.split(".")]
    return f"{year}.{month:02}.{day:02}"


def main():
    latest = get_latest_version()
    current = get_current_version()
    print(f"Latest is {latest}")
    print(f"Current is {current}")

    if latest != current:
        print(f"yt-dlp {current} -> {latest}")
        set_version(latest)
        with open("x.sh", "wt") as f:
            f.write(f"#!/bin/sh\n")
            f.write("git config --global user.email 'git.sbstp.ca@gmail.com'")
            f.write("git config --global user.name 'Automated Update'")
            f.write(f"git commit -am 'Update to {pad_version(latest)}'\n")
            f.write(f"git tag -a -m '' {latest}\n")
            f.write(f"git push --follow-tags\n")
        os.chmod("x.sh", 0o755)
        subprocess.check_call(["./x.sh"])
    else:
        print(f"Up to date {current} == {latest}")


main()
