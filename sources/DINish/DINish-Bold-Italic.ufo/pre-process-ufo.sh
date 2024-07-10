#!/bin/sh

set -e

orig="$1"
echo -n 'Preprocessing in '
pwd

[ -e glyphs ] || mkdir glyphs
cp -n "$orig/sources/DINish/DINish-Bold.ufo/"*.* .
cp -n "$orig/sources/DINish/DINish-Bold.ufo/glyphs/"*.* glyphs
python "$orig"/tools/copy-missing-italics.py \
  --source="$orig/sources/DINish/DINish-Bold.ufo" --dest=. \
  --uprights="$orig"/sources/upright-in-italic-dinish.enc \
  --overwrite="a=a.ss02"
