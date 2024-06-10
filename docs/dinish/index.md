---
layout: default
title: DINish -- a fresh take on a classic typeface
permalink: /dinish/
---

![DINish](/din-vs-dinish.jpeg "DIN vs DINish")

## Introduction

DINish is one of many modern computer fonts that were inspired by the
lettering of the German Autobahn road signs. It is professionally
designed, and usable for body text and captions, even spreadsheets!
Its unadorned style is easy to read, and although it is close to a
century old maintains a fresh look.

This DIN font is free to use, for desktop use, e-books, as a web font,
or just to tinker with.

## About the name

The name DINish refers to the fact that the typeface looks like DIN 1451.
Actually, a quick comparison with the standard as can be found in historic
sources shows DINish to not be fully compatible with the standard,
at least not as it was in 1931. That is probably a good thing.

Reading the DIN 1451 standard with modern eyes reveals that it is
more like a lettering standard for technical drawings than a typeface
specification. The standard has no concern for how the brain processes
shapes and whitespace. DINish was drawn with the human reader in
mind, with subtle but loving exceptions to the rigid grid-and-ruler
specification from the _Deutsche Norm_. That said, it retains DIN's
clarity and as such it is a typeface with a purpose, if not a mission.

DINish is available in three widths: standard, Condensed and Expanded. The
standard width roughly matches DIN Mittelschrift, the Condensed width
roughly matches the DIN Engschrift, and Expanded is like DIN
Breitschrift (rarely used in Germany, actually). There are Regular,
Bold and Italic variants.

## Historic roots

DIN 1451 is a [sans-serif](https://en.wikipedia.org/wiki/Sans-serif) typeface
that is widely used for traffic, administrative and technical applications.

It was defined by the German standards body DIN -
[Deutsches Institut für Normung](https://en.wikipedia.org/wiki/Deutsches_Institut_f%C3%BCr_Normung)
(German Institute for Standardization) in the standard sheet DIN 1451-Schriften (typefaces)
in 1931. Similar standards existed for stencilled letters.

Originally designed for industrial uses, the first DIN-type fonts were a
simplified design that could be applied with limited technical difficulty.
Due to the design's legibility and uncomplicated, unadorned design, it has
become popular for general purpose use in signage and display adaptations.
Many adaptations and expansions of the original design have been released
digitally.

See [https://en.wikipedia.org/wiki/DIN_1451](https://en.wikipedia.org/wiki/DIN_1451) for more information.

## Language support

DINish now fully supports almost all European Latin languages as per
https://r12a.github.io/app-charuse/.  In total, 243 Latin-based languages
are supported. Please open an issue on Github if any European language
based on Latin characters is not rendered with proper typographical
conventions. There is special handling in OpenType for the Polish and
Romanian languages. Version v3.006 introduces support for at least six
languages using Cyrillic.


## OpenType Features

By default, numbers are proportionally spaced. For use in spreadsheets
or other tabular document formats, tabular numbers are available that
line up vertically.  In libreOffice, use the Features button in the
Font Style dialog, or type the font name as `Dinish:tnum` in the font
selector. In CSS, use `font-feature-settings: "tnum";`.

DINish comes with a full set of old style numerals. These can be
selected with the `onum` tag. They are even available in tabular form
for use in spreadsheets: in libreOffice, use `Dinish:onum&tnum`. For
CSS, try `font-feature-settings: "onum", "tnum";`.

The Polish language uses a different style of acute accent called
kreska. In libreOffice set the document language to Polish. HTML/CSS
picks up the kreska when you set the document language to Polish.

The Romanian language apparently received short shrift in the initial
Unicode specification, which was later rectified by adding separate
Unicode glyphs for letters with comma accents. DINish includes the
OpenType magic to recognise the previous Unicode codes and do the right
thing when the language is set to Romanian. And yes, feel free to use
DINish for the design of the next Romanian bank notes.

The Dutch language has an ij digraph. If you prefer, you can enable the
ss01 stylistic alternate to automatically substitute ij with ĳ.

Version v3.005 comes with full support for the
[frac feature](https://fonts.playbeing.com/dinish/features#frac),
which translates fractions like 3/4 into the classic ¾ notation.

Version v3.006 introduces support for Cyrillic, contributed by Stefan
Peev. It includes support for multiple languages, including alternate
letterforms needed for Bulgarian. Because few native speakers had a
chance to look at the result, support for Cyrillic is considered beta
quality in v3.006. That said, at least six major languages can now be set
in DINish, and the glyphs look like they've always been part of DINish,
so thank you, Stefan!

## DINish demo pages

See the [features page](https://fonts.playbeing.com/dinish/features) for
usage examples. For inspiration, look at the
[serving suggestions](https://fonts.playbeing.com/dinish/showcase).
An interactive [font specimen](https://fonts.playbeing.com/dinish/specimen)
shows the character set. The pangram shown there is editable; try your
own text, and feel free to play with the size and the font variations!

## As a webfont

As DINish is not yet available on any of the major free font CDNs, you
will have to host the font yourself. Fortunately, the font is light
in weight: the [DINish font homepage](https://fonts.playbeing.com/dinish)
contains two styles of DINish in just 30k worth of CSS. Chances are
that one JPEG image adds more weight to your page!
On the [Github page](https://github.com/playbeing/dinish/tree/master/tools),
you'll find a quick Python script to convert a woff2 file into
embeddable CSS. Quick tip, not just for this font: use a tool like
SASS to merge and compress your CSS. This will cause fewer hits on the
webserver, which automatically translates into a faster site for
your visitors!
In Jekyll, that is a [trivial change](https://github.com/playbeing/dinish/commit/4467855a292e0bd58ff7d933b7ef2148098eba66).

## Information for Contributors

This Font Software is licensed under the [SIL Open Font License, Version 1.1](https://raw.githubusercontent.com/playbeing/dinish/master/OFL.txt).

In the spirit of Open Source, we're taking patches. Please open an issue on [Github](https://github.com/playbeing/dinish/issues).

[Fontmake](https://github.com/googlefonts/fontmake) is used for generating
fonts, as are [SIL's pysilfont](https://github.com/silnrsi/pysilfont),
[Google's fontbakery](https://github.com/googlefonts/fontbakery) and
[gf-tools](https://github.com/googlefonts/gftools). Both
[FontForge](https://github.com/fontforge/fontforge) and
[TruFont](https://github.com/trufont/trufont) have proven invaluable
for editing.

Copyright © 2023-2024 Stefan Peev (https://github.com/StefanPeev/dinish/tree/cyrillic)\
Copyright © 2021-2024 Bert Driehuis (https://github.com/playbeing/dinish)\
Copyright © 2019 Altinn (https://github.com/Altinn/altinn-din)\
Copyright © 2017 Datto Inc. (https://www.datto.com/fonts/d-din)

Also see [FONTLOG.txt](https://raw.githubusercontent.com/playbeing/dinish/master/FONTLOG.txt).

## Acknowledgements

The [DINish](https://github.com/playbeing/dinish) font is derived from
[Altinn-DIN](https://github.com/Altinn/altinn-din), which in turn is
based on Datto's [D-DIN](https://web.archive.org/web/20210204024059/https://www.datto.com/fonts/d-din/). Datto
commissioned Monotype to create D-DIN and open source it.
Monotype's Creative Type Director
[Charles Nix](https://www.monotype.com/studio/charles-nix)
did the original design.
Many glyphs have been touched since then, and any errors are the responsibility of the contributors who followed in his footsteps.
The font is made available under the [SIL Open Font License v1.1](https://raw.githubusercontent.com/playbeing/dinish/master/OFL.txt).

## ChangeLog

For details see [FONTLOG.txt](https://raw.githubusercontent.com/playbeing/dinish/master/FONTLOG.txt).

- 2024-06-09 - v3.006: Integrate Cyrillic glyphs & features by Stefan Peev. Supports multiple languages, including Bulgarian. Fixes for Dutch accented ij.
- 2023-04-28 - v3.005: Full support for frac feature.
- 2023-11-26 - v3.004: Extended Cyrillic and extended Latin. Update VF. Unreleased due to production issues.
- 2023-11-16 - v3.003: Cyrillic glyphs for Russian, Serbian, Bulgarian languages. VF for regular thru bold weights. Unreleased due to production issues.
- 2022-07-23 - v3.002: Add uppercase Esszet and Dutch IJ/ij digraphs (with ss01 stylistic alternate), U/u with breve and dotless j.
- 2022-07-13 - v3.001: Reworked vertical metrics, may cause line spacing changes.
- 2021-10-22 - v2.013: Add missing glyphs for Northern Sámi
- 2021-09-28 - v2.012: Usability update: make negative numbers look right in spreadsheets.
- 2021-09-19 - v2.011: Add missing glyphs for around 50 languages. Includes full support for Romanian.
- 2021-09-07 - v2.010: Add Polish locl feature to use kreska instead of acute, add Hungarian umlaut.
- 2021-09-01 - v2.009: Add old style numerals.
- 2021-08-30 - v2.008: Add old style numerals (release pulled due to production issues).
- 2021-08-27 - v2.007: Add support for the Polish language. Misc fixes, see FONTLOG.
- 2021-06-09 - v2.006: Add DINish Condensed Italic to complete the family
- 2021-06-06 - v2.005: Add missing glyphs for Turkish language, add lower case alpha.
- 2021-05-25 - v2.004: Add tabular numbers (OpenType tnum feature), minor cleanups
- 2021-04-24 - v2.003: Split into three families, minor cleanups
- 2021-04-13 - v2.002: Renamed to DINish, cleaned up for submission to Google Fonts
- 2021-04-03 - v2.001: Converted to ufo, see NOTES.md
- 2019-11-20 - v2.0: Renamed D-DIN to Altinn-DIN to be able to do minor modifications
- 2017-10-26 - v1.0: First public release
