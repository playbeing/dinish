This repository was initially created from the Altinn-DIN git repo using this process:

```
git clone https://github.com/Altinn/altinn-din
mkdir ufo
cd src
for font in *.sfd; do fontforge -c 'open(argv[1]).generate(argv[2])' "$font" ../ufo/`basename "$font" .sfd`.ufo; done
```

A workflow was set up in the form of a naive Makefile (in particular, it
does not contain full dependencies, so running `make` without a preceding
`make clean` does not guarantee that all changes are reflected in the
generated fonts). This workflow requires these tools (in parentheses the
versions used for the 2.002 release).

* FontForge (20190801)
* fontbakery (0.7.34)
* gftools (0.7.0)
* psfnormalize (1.5.1.dev0)
* ttfautohint (1.8.3)

We performed many manual touchups on the sources, including:

* adding missing glyphs
* re-ordering all outlines that did not start with a
  drawing operator; now FontForge and TruFont properly show the
  outlines
* assigning proper names to a number of glyphs
* making many minor corrections to the font tables and adding missing
  entries
* renaming the family to DINish
* splitting the sources into three families: DINish, DINish condensed
  and DINish expanded
* making the naming consistent within the families
* correcting PANOSE entries
* Renamed the font again, this time to Dinish, to avoid opening a can
  of worms involving CamelCase. But remember, the correct pronunciation
  is still "DINish"!

There are a few warnings flagged by fontbakery that we chose not to address.
In particular:

* `com.google.fonts/check/outline_alignment_miss`: we tracked down a
  bunch of them, and the ones we analyzed in depth were all false
  positives.
* `com.google.fonts/check/outline_short_segments`: These are valid
  concerns, but at under 24KB for the full .otf, and under 11K for
  a .woff, the benefits of replacing a handful of splines, each with
  one short straight segment, with a redrawn spline that obviates the
  straight line just isn't worth it.
* `com.google.fonts/check/kerning_for_non_ligated_sequences`: fontbakery
  seems to complain about non-existing ligatures.
