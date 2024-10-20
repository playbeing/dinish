#! env python

from fontParts.world import OpenFont, NewFont
from fontTools.misc import transform

import argparse
import sys

def dedup_list(mylist):
    mylist = list(dict.fromkeys(mylist))


def sort_font_glyphs(f):
    sort_descriptor = [
        dict(type="alphabetical", ascending=True, allowPseudoUnicode=True),
        dict(type="unicode", ascending=True, allowPseudoUnicode=True)
        ]
    newGlyphOrder = f.naked().unicodeData.sortGlyphNames(f.glyphOrder, sortDescriptors=sort_descriptor)
    f.glyphOrder = newGlyphOrder


def nuke_anchors(files):
    fontlist = {}
    changes = {}
    glyph_names = set(())
    nuked = 0
    changed = 0
    for file in files:
        fontlist[file] = OpenFont(file)
        glyph_names = glyph_names.union(fontlist[file].keys())

    # iterate over the glyph names
    for glyphName in glyph_names:
        ok = True
        for file in files:
            if glyphName not in fontlist[file]:
                print(f'{glyphName} not in {file}, skipping…')
                ok = False
                break
        if not ok: continue

        for index, file in enumerate(files[1:]):
            anchors1 = [x.name for x in fontlist[file][glyphName].anchors]
            anchors1.sort()
            anchors2 = [x.name for x in fontlist[files[index]][glyphName].anchors]
            anchors2.sort()
            if anchors1 != anchors2:
                for file in files:
                    f = fontlist[file]
                    f[glyphName].clearAnchors()
                    changes[file] = True
                    nuked += 1
                break

    if nuked > 1:
        for file in files:
            fontlist[file].save()
            changed += 1

    print("{0} anchors nuked from {1} fonts".format(nuked, changed))


def main():
    parser = argparse.ArgumentParser(description="Nuke inconsistent anchors from a number of .ufo's, overwriting the original")
    parser.add_argument("files", nargs='*')
    args = parser.parse_args()
    nuke_anchors(args.files)
    sys.exit(0)


main()
# vim: ai ts=4 sts=4 et sw=4 ft=python
