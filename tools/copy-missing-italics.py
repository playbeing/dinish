#!/usr/bin/python3

from fontParts.world import OpenFont
from fontParts.fontshell import RContour
import argparse
import glob
import math
import os
import re
import shutil
import sys
import xmltodict


def fatal(str):
    print(str)
    sys.exit(1)


def parse_uprights(infile):
    upright_list = []
    with open(infile) as f:
        for line in f.readlines():
            if re.match(r"^[^%].", line):
                upright_list.append(line.strip())
    return upright_list


def glyph_assert_has_contours(fontname, glyph):
    if len(glyph.contours) == 0:
        fatal("Font {0} glyph {1} has no contours, should be nonzero".format(fontname, glyph))
    if len(glyph.components) != 0:
        fatal("Font {0} glyph {1} has {2} components, should be zero".format(fontname, glyph, glyph.components))


def copy_glyphs_to_italic(source, dest, upright_list):
    srcfont = OpenFont(source)
    dstfont = OpenFont(dest)
    print("Processing {0} -> {1}".format(source, dest))
    with open("{0}/glyphs/contents.plist".format(source), "r") as f:
        doc = xmltodict.parse(f.read())
        glyphs = dict(zip(doc["plist"]["dict"]["key"], doc["plist"]["dict"]["string"]))
        files = dict(zip(doc["plist"]["dict"]["string"], doc["plist"]["dict"]["key"]))

    # Check that all .glifs are there, and that none are superfluous
    for path in glob.glob("{0}/glyphs/*.glif".format(source)):
        file = os.path.basename(path)
        if file in files:
            del files[file]
        else:
            print("File {0} not found in contents.plist for {1}".format(file, source))
    if len(files) > 0:
        print("contents.plist for {0} refers to nonexistent files: {1}".format(source, files))

    for glyph_name in glyphs.keys():
#        file = glyphs[glyph_name]
#        if os.path.exists("{0}/glyphs/{1}".format(dest, file)):
#            continue
        if glyph_name in upright_list:
            print("Not slanting {0}".format(glyph_name))
            upright_list.remove(glyph_name)
            continue
        unicode = srcfont[glyph_name].unicode
        if unicode:
            #import pdb; unicode > 0x2000 and pdb.set_trace()
            lookup = "uni%04X" % unicode
            if lookup in upright_list:
                print("Not slanting {0}".format(lookup))
                upright_list.remove(lookup)
                continue

        glyph = srcfont[glyph_name]
        #print("Overwriting {0}".format(glyph_name))
        dstfont.newGlyph(glyph_name)
        newglyph = dstfont[glyph_name]
        #import pdb; pdb.set_trace()
        slant = math.sin(math.radians(12))
        half_x_height = 529.0 / 2.0
        for component in srcfont[glyph_name].components:
            (x, y) = component.offset
            x += y * slant;
            newglyph.appendComponent(component.baseGlyph, (x, y))
        for contour in srcfont[glyph_name].contours:
            newcontour=RContour()
            for point in contour.points:
                xnew = point.x + ((point.y - half_x_height) * slant)
                newcontour.appendPoint((xnew, point.y), point.type, point.smooth)
            newglyph.appendContour(newcontour)

        newglyph.unicode = unicode
        newglyph.name = glyph_name
        newglyph.width = glyph.width

    if len(upright_list) > 0:
        print("Unused items in upright list: {0}".format(', '.join(upright_list)))
    #pdb.set_trace()
    dstfont.save()


def main():
    parser = argparse.ArgumentParser(description="Copy glyphs to a slanted sister font")
    parser.add_argument("--source")
    parser.add_argument("--dest")
    parser.add_argument("--uprights")
    args = parser.parse_args()
    upright_list = parse_uprights(args.uprights)
    copy_glyphs_to_italic(args.source, args.dest, upright_list)


main()
# vim: ai ts=4 sts=4 et sw=4 ft=python
