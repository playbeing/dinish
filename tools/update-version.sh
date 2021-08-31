#!/bin/sh

# Update the fontinfo.plist for all fonts:
#   Version major/minor is set to the version from the git tag, e.g. v2.006
#
#   openTypeNameVersion is set to Version: tag; git-hash-release
#   (e.g., Version: v2.006; git-1a2b3c4d-release) for releases built from
#   the git tag, or to Version: tag; git-hash+revs-mods-dev for dev
#   builds, e.g., Version 2.006; git-3ccbb4c+36-13-dev .
#   The +36 indicates that this build is 36 commits ahead of 2.006.
#   The -13 indicates that there are uncommitted changes to 13
#   files, and that the build is not reproducable.
#
#   openTypeHeadCreated is set to the build date and time.


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
major=`echo $major|sed -e 's/^0*//'`
minor=`echo $minor|sed -e 's/^0*//'`
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
    hash="$hash+$revs-$modified"
    status=dev
fi
version=`printf "%d.%03d" $major $minor`
versionstr="Version $version; git-$hash-$status"
now=`date +'%Y/%m/%d %H:%M:%S'`

echo $versionstr

for ufo in sources/Dinish*/Dinish*.ufo
do
	sed -i -e "/versionMajor/,+1s/>[0-9]*</>$major</" \
        -e "/versionMinor/,+1s/>[0-9]*</>$minor</" \
        -e "/openTypeHeadCreated/,+1s#>[0-9].*<#>$now<#" \
        -e "/openTypeNameVersion/,+1s/>Version [0-9.]*</>$versionstr</" $ufo/fontinfo.plist
done
