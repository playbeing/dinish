#!/bin/sh

# Git tag looks like v2.006-29-g44c73e7
# We first split on dash:
read tag revs hash <<EOD
`git describe --tags --long|tr - ' '`
EOD
# Remove the leading 'g' from the hash:
hash=`echo $hash | sed -e s/^g//`
modified=`git status -s -uno |grep -v ' fonts/'|wc -l`

read major minor <<EOD
`echo $tag|tr -d Vv|tr . ' '`
EOD
major=`printf %d $major`
minor=`printf %d $minor`
case $major:$minor in
	[0-9]*:[0-9]*)
		;;
	*)
		echo "Malformed version string in git tag $tag; please fix before publishing; aborting!"
		exit 1
	;;
esac

if [ $modified = 0 ] && [ $revs = 0 ]; then
    status=release
else
    if [ $modified -gt 0 ]; then
        hash="$hash+$modified"
    fi
    status=dev
fi
version=`printf "%d.%03d" $major $minor`
versionstr="Version $version; git-$hash-$status"

echo $versionstr

for ufo in sources/Dinish*/Dinish*.ufo
do
	sed -i -e "/versionMajor/,+1s/>[0-9]*</>$major</" -e "/versionMinor/,+1s/>[0-9]*</>$minor</" -e "/openTypeNameVersion/,+1s/>Version [0-9.]*</>$versionstr</" $ufo/fontinfo.plist
done
