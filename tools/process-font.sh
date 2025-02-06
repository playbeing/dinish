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
		case "$in" in
			*.ttf)
				in_ttf="$in"
				;;
			*)
				fontmake --flatten-components --verbose WARNING --overlaps-backend pathops --ufo-paths $in -o ttf --output-path $out.ttf
				[ "$?" = "0" ] || die "fontmake failed"
				in_ttf="$out.ttf"
				;;
		esac
		python3 -c "from fontTools.ttLib import TTFont; f = TTFont('$in_ttf');f.flavor='$outtype';f.save('$out')"
		[ "$?" = "0" ] || die "conversion to $outtype failed"
		if [ "$in_ttf" != "$out.ttf" ]; then
			rm -f $out.ttf
		fi
		exit 0;;
esac

fontmake --flatten-components --verbose WARNING --overlaps-backend pathops --ufo-paths $in -o $outtype --output-path $out
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
