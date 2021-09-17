#!/bin/sh

zero_xoffset_files=`find "$@" -name '*.glif' -exec grep --files-with-matches ' [xy]Offset="0"' {} +`
if [ -n "$zero_xoffset_files" ]; then
    sed -i -e 's/ [xy]Offset="0"//g' $zero_xoffset_files
fi
exit 0
