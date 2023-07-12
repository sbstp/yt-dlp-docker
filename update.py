import re
import requests
from pathlib import Path
from xml.etree import ElementTree


def get_latest_version() -> str:
    resp = requests.get("https://pypi.org/rss/project/yt-dlp/releases.xml")
    resp.raise_for_status()
    rss = ElementTree.fromstring(resp.text)
    channel = rss.findall('channel')[0]
    versions = channel.findall('item')
    return versions[0].find("title").text


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
    if latest != current:
        print(f"yt-dlp {current} -> {latest}")
        set_version(latest)
        print(f"Updated Dockerfile to version {latest}")
        print(f"Please run: git commit -am 'Update to {pad_version(latest)}'")
        print(f"Please run: git tag {latest}")
        print(f"Please run: git push --tags")
    else:
        print(f"Up to date {current} == {latest}")


main()