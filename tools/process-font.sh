#!/bin/sh

set -e

in="$1"
out="$2"
outtype="`echo $out | sed -e 's/.*\.//'`"

die() {
	echo "$@"
	exit 1
}

# If we have a pre-process script, we copy the source to a temp folder
# in order to be able to massage the source without touching the
# source controlled source.
# The script gets call with its original folder as the first argument
if [ -f "$in/pre-process-ufo.sh" ]; then
	tempdir=`mktemp -d "/tmp/process-font-XXXXXXXX.ufo" 2>/dev/null`
	orig="`pwd`"
	cp -pr "$in/"* "$tempdir"
	( cd "$tempdir" ; sh pre-process-ufo.sh "$orig" )
	in=$tempdir
fi

case "$outtype" in
	woff|woff2)
		fontmake --verbose WARNING --overlaps-backend pathops --ufo-paths $in -o ttf --output-path $out.ttf
		[ "$?" = "0" ] || die "fontmake failed"
		python3 -c "from fontTools.ttLib import TTFont; f = TTFont('$out.ttf');f.flavor='$outtype';f.save('$out')"
		[ "$?" = "0" ] || die "conversion to $outtype failed"
		rm -f $out.ttf
		exit 0;;
esac

fontmake --verbose WARNING --overlaps-backend pathops --ufo-paths $in -o $outtype --output-path $out
[ "$?" = "0" ] || die "fontmake failed"

# 20210825 We stop adding a dummy dsig table after fontbakery 0.8.1 started complaining
# about the table we added because fontbakery 0.7 required it :-)

#res="`gftools fix-dsig --autofix $out 2>&1`"
#rv=$?
#echo "$res" | grep -Ev '(so we just added a dummy placeholder)' || true
#[ "$rv" = "0" ] || die "gftools fix-dsig failed"

case "$out" in
	*.ttf)
		tmpout="tmp-$$.ttf"
		ttfautohint $out $tmpout
		mv $tmpout $out

		res="`gftools fix-hinting $out 2>&1`"
		rv=$?
		echo "$res" | grep -Ev '(^$|Saving.* to .*.fix$)' || true
		[ "$rv" = "0" ] || die "gftools fix-hinting failed"
		mv $out.fix $out

		;;
esac

if [ -e /tmp/keep-generated.txt ]; then
	exit 0
fi

if [ -e "$tempdir" ]; then
	rm -rf "$tempdir"
fi
