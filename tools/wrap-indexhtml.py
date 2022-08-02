#!/bin/env python3

import base64
import re


MIME_MAP = {
    "css": "text/css",
    "js": "text/javascript",
    "woff": "font/woff",
    "woff2": "font/woff2",
}

PLAUSIBLE_HTML='<script defer data-domain="fonts.playbeing.com" src="https://plausible.playbeing.com/js/plausible.js"></script>'


def make_data_url(url_match):
    filename = url_match.group(2)
    print("Expanding {0}".format(filename))
    m = re.search(r'\.(\w+)$', filename)
    if m:
        ext = m.group(1)
    else:
        raise ValueError("no extension in {0}".format(filename))
    if ext not in MIME_MAP:
        raise ValueError("unknown extension {0}".format(ext))
    prefix = 'data:{0};base64,'.format(MIME_MAP[ext])
    if ext == 'woff2':
        with open(filename, 'rb') as fin:
            contents = fin.read()
            data_url = prefix + base64.b64encode(contents).decode('utf-8')
    else:
        with open(filename, 'r') as fin:
            contents = fin.read()
            contents = expand_includes(contents)
            data_url = prefix + base64.b64encode(contents.encode()).decode('utf-8')
    return url_match.group(1) + data_url + url_match.group(3)


# url(./fonts/Dinish-Bold.88bb639c95258fc34ef3452faa41a062.woff2)
# <link rel="stylesheet" href="./styles.aaaa71d88bf6e801df57.css">
# <script defer="defer" src="./main.9d61bef68991d1d4839f.js"></script>
def expand_includes(contents):
    contents = re.sub(r'(url\()(\.\/[^)]+)(\))', make_data_url, contents)
    contents = re.sub(r'((?:src|href)=")(\.\/[^"]+\.(?:js|css))(")', make_data_url, contents)
    return contents


with open("index.html", "r") as infile:
    with open("index-combined.html", "w") as outfile:
        contents = infile.read()
        contents = expand_includes(contents)
        contents = re.sub('(</html>)', PLAUSIBLE_HTML + "\1", contents)
        outfile.write(contents)


# vim: ai ts=4 sts=4 et sw=4 ft=python
