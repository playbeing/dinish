This font was created from the Altinn-DIN git repo using this process:

```
git clone https://github.com/driehuis/altinn-din	# freshly cloned off of https://github.com/Altinn/altinn-din
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
