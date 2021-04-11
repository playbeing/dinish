#!/bin/sh

in="$1"
out="$2"

die() {
	echo "$@"
	exit 1
}

res="`fontforge -c 'open(argv[1]).generate(argv[2])' $in $out 2>&1`"
rv=$?
echo "$res" | grep -Ev '(See AUTHORS|License GPLv3|with many parts BSD|Version: 201|Based on sources)' || true
[ "$rv" = "0" ] || die "fontforge failed"

case "$2" in
	*.woff|*.woff2)
		exit 0;;
esac

res="`gftools fix-unwanted-tables $out 2>&1`"
rv=$?
echo "$res" | grep -Ev '(since they are not in the font)' || true
[ "$rv" = "0" ] || die "gftools fix-unwanted-tables failed"
res="`gftools fix-dsig --autofix $out 2>&1`"
rv=$?
echo "$res" | grep -Ev '(so we just added a dummy placeholder)' || true
[ "$rv" = "0" ] || die "gftools fix-dsig failed"
