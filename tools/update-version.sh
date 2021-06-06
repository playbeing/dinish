#!/bin/sh

major=$1
minor=$2
case $major:$minor in
	[0-9]*:[0-9]*)
		;;
	*)
		echo "Usage: $0 major minor"
		exit 1
	;;
esac
version=`printf "%d.%03d" $major $minor`

for ufo in sources/Dinish*/Dinish*.ufo
do
	sed -i -e "/versionMajor/,+1s/>[0-9]*</>$major</" -e "/versionMinor/,+1s/>[0-9]*</>$minor</" -e "/openTypeNameVersion/,+1s/>Version [0-9.]*</>Version $version</" $ufo/fontinfo.plist
done
