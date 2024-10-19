#! env python

"""
Interpolate font weights, based on a 400 and a 700 weight font. This
will probably require a ton of tweaks for the extreme weights (100,
200, 800 and 900), but it will probably be a good start.
For DINish, the 300, 500, 600 and 800 are usable as is.
"""

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


def interpolate_font(src1, src2, dest, weight):
    # get fonts
    font1 = OpenFont(src1)
    font2 = OpenFont(src2)
    # Note that we're not saving the new font to the original file, so this is safe
    newfont = OpenFont(src1)

    # define interpolation factor. Regular is 0.0, Bold is 1.0. Adjust
    # this if your source weights are not 400 and 700.
    factor = (weight - 4.0) / 3.0

    incompatibilities = 0

    # iterate over the glyph names
    for glyphName in font1.keys().union(font2.keys()):

        # if this glyph is not available in one of the masters, skip it
        if glyphName not in font1:
            print(f'{glyphName} not in {font1}, skipping…')
            continue
        if glyphName not in font2:
            print(f'{glyphName} not in {font2}, skipping…')
            continue

        # if the glyph does not exist in the destination font, create it
        if glyphName not in newfont:
            newfont.newGlyph(glyphName)

        compatible, report = font1[glyphName].isCompatible(font2[glyphName])
        if not compatible:
            incompatibilities += 1
            print(report)

        # interpolate glyph
        # print(f'interpolating {glyphName}…')
        newfont[glyphName].interpolate(factor, font1[glyphName], font2[glyphName])
        newfont[glyphName].unicode = font1[glyphName].unicode

    newfont.kerning.interpolate(factor, font1.kerning, font2.kerning)

    sort_font_glyphs(newfont)

    weight_names = {1: 'Hairline', 2: 'Thin', 3: 'Light', 5: 'Medium', 6: 'SemiBold', 8: 'Heavy', 9: 'Black'}
    family_name = font1.info.familyName
    weight_name = weight_names[weight]
    simple_style = "regular"
    if weight == 7:
        simple_style = "bold"
    style_name = weight_name
    #newfont.info.openTypeNamePreferredFamilyName = family_name
    #newfont.info.openTypeNamePreferredSubfamilyName = style_name
    #newfont.info.openTypeNameUniqueID = TBD
    newfont.info.openTypeOS2WeightClass = weight * 100
    newfont.info.postscriptFontName = (family_name + '-' + weight_name).replace(' ', '')
    newfont.info.postscriptFullName = family_name + ' ' + style_name
    newfont.info.postscriptWeightName = weight_name
    if weight in weight_names:
        newfont.info.styleMapFamilyName = family_name + ' ' + weight_names[weight]
    else:
        newfont.info.styleMapFamilyName = family_name
    newfont.info.styleMapStyleName = simple_style
    newfont.info.styleName = weight_name
    newfont.info.openTypeOS2Panose[2] = weight + 1

    # done!
    newfont.save(dest)

    print("{0} incompatibilities seen".format(incompatibilities))
    if incompatibilities > 0:
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Interpolate between two fonts")
    parser.add_argument("--dest", nargs=1, required=True)
    parser.add_argument("--weight", nargs=1, required=True, type=int)
    parser.add_argument("file", nargs=2)
    args = parser.parse_args()
    interpolate_font(args.file[0], args.file[1], args.dest[0], args.weight[0])
    sys.exit(0)


main()
# vim: ai ts=4 sts=4 et sw=4 ft=python
