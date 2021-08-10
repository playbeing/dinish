#!/bin/sh

in="$1"
out="$2"
outtype="`echo $out | sed -e 's/.*\.//'`"

die() {
	echo "$@"
	exit 1
}

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

res="`gftools fix-dsig --autofix $out 2>&1`"
rv=$?
echo "$res" | grep -Ev '(so we just added a dummy placeholder)' || true
[ "$rv" = "0" ] || die "gftools fix-dsig failed"

case "$out" in
	*.ttf)
		tmpout="tmp-$$.ttf"
		ttfautohint $out $tmpout
		mv $tmpout $out
		;;
esac
