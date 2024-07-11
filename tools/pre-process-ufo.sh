#!/bin/sh

# Run manually to sync an italic font from its upright precursor.

set -e

die() {
	echo "$@"
	exit 1
}

[ -e tools ] || die "Run this script from the toplevel directory as ./tools/pre-process-ufo.sh"

topdir="`pwd`"
tempdir=`mktemp -d "/tmp/process-font-XXXXXXXX" 2>/dev/null`
cd $tempdir
fontname=DINish-BoldItalic.ufo
mkdir $fontname
cd $fontname

[ -e glyphs ] || mkdir glyphs
cp -n "$topdir/sources/DINish/DINish-Bold.ufo/"*.* .
cp -n "$topdir/sources/DINish/DINish-Bold.ufo/glyphs/"*.* glyphs
python "$topdir"/tools/copy-missing-italics.py \
  --source="$topdir/sources/DINish/DINish-Bold.ufo" --dest=. \
  --uprights="$topdir"/sources/upright-in-italic-dinish.enc \
  --overwrite="a=a.ss02"

echo "Font source created in `pwd`"
