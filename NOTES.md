This font was created from the Altinn-DIN git repo using this process:

```
git clone https://github.com/driehuis/altinn-din	# freshly cloned off of https://github.com/Altinn/altinn-din
mkdir ufo
cd src
for font in *.sfd; do fontforge -c 'open(argv[1]).generate(argv[2])' "$font" ../ufo/`basename "$font" .sfd`.ufo; done
```
