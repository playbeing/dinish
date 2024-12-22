#!/bin/bash

set -e

toolsdir=/src/tools
srcdir=/src
scratch=/scratch

rm -rf /scratch/* /scratch/.??*
rsync -raWH --delete $srcdir/./ $scratch/./
cd $scratch

version=`tools/update-version.sh`
echo $version
case "$version" in
    *-release)
        echo Building for release
        preview=""
        git clean -df
    ;;
    *)
        echo Building preview
        preview="Preview"
    ;;
esac

cd $scratch/sources
mkdir vfwork

for f in DINish DINishCondensed DINishExpanded
do
    masterdir=DINish/DINish-Regular.ufo
    for s in Regular Bold
    do
        dir=$f/$f-$s.ufo
        if [ $dir != $masterdir ]; then
            cp $masterdir/features.fea $dir/
        fi
    done
done

# Generate VF "masters"
for f in DINish DINishCondensed DINishExpanded
do
    mkdir -p $scratch/sources/vfwork/$f
    cp -r $f/$f-Regular.ufo $scratch/sources/vfwork/$f/$f-Regular.ufo
    python $toolsdir/interpolate-font.py --dest=$scratch/sources/vfwork/$f/$f-Heavy.ufo --weight=8 $f/$f-{Regular,Bold}.ufo
    for weight in Regular Heavy
    do
        if [ "$weight" = "Regular" ]; then
            stylename="Italic"
        else
            stylename="${weight}Italic"
        fi
        cp -r $scratch/sources/vfwork/$f/$f-$weight.ufo $scratch/sources/vfwork/$f/$f-${stylename}.ufo
        python $srcdir/tools/copy-missing-italics.py \
            --source $scratch/sources/vfwork/$f/$f-$weight.ufo \
            --dest $scratch/sources/vfwork/$f/$f-$stylename.ufo \
            --uprights $srcdir/sources/upright-in-italic-dinish.enc
    done
done

# Generate static masters
for f in DINish DINishCondensed DINishExpanded
do
    python $toolsdir/interpolate-font.py --dest=$scratch/sources/$f/$f-Light.ufo --weight=3 $f/$f-{Regular,Bold}.ufo
    python $toolsdir/interpolate-font.py --dest=$scratch/sources/$f/$f-Medium.ufo --weight=5 $f/$f-{Regular,Bold}.ufo
    python $toolsdir/interpolate-font.py --dest=$scratch/sources/$f/$f-SemiBold.ufo --weight=6 $f/$f-{Regular,Bold}.ufo
    python $toolsdir/interpolate-font.py --dest=$scratch/sources/$f/$f-Heavy.ufo --weight=8 $f/$f-{Regular,Bold}.ufo
    #python $toolsdir/interpolate-font.py --dest=$scratch/sources/$f/$f-Black.ufo --weight=9 $f/$f-{Regular,Bold}.ufo
    for weight in Light Regular Medium SemiBold Bold Heavy
    do
        if [ "$weight" = "Regular" ]; then
            stylename="Italic"
        else
            stylename="${weight}Italic"
        fi
        cp -r $scratch/sources/$f/$f-$weight.ufo $scratch/sources/$f/$f-${stylename}.ufo
        python $srcdir/tools/copy-missing-italics.py \
            --source $scratch/sources/$f/$f-$weight.ufo \
            --dest $scratch/sources/$f/$f-$stylename.ufo \
            --uprights $srcdir/sources/upright-in-italic-dinish.enc \
            --overwrite a=a.ss02
    done
done

cd $scratch
if [ "$preview" = "Preview" ]; then
    find $scratch -name .git -prune -o -type f -exec sed -i -e 's/DINish/DINishPreview/g' {} +
    rename 's/DINish/DINishPreview/g;s/PreviewPreview/Preview/g' $scratch/sources/DIN*
    rename 's/DINish/DINishPreview/g;s/PreviewPreview/Preview/g' $scratch/sources/DIN*/DIN*.ufo
    rename 's/DINish/DINishPreview/g;s/PreviewPreview/Preview/g' $scratch/sources/vfwork/DIN*
    rename 's/DINish/DINishPreview/g;s/PreviewPreview/Preview/g' $scratch/sources/vfwork/DIN*/DIN*.ufo
    mkdir -p ofl/dinish ofl/dinishexpanded ofl/dinishcondensed
    ln -s ../ofl/dinish ofl/dinishpreview
    ln -s ../ofl/dinishexpanded ofl/dinishpreviewexpanded
    ln -s ../ofl/dinishcondensed ofl/dinishpreviewcondensed
fi

# Until we clean up the anchor mess...
python $toolsdir/nuke-inconsistent-anchors.py $scratch/sources/vfwork/DINish*/DINish*.ufo

# Nuke the 'Regular' bit from the internal font name of the VF
sed -i -e 's/\(DINish[A-Za-z]*\).Regular/\1/' $scratch/sources/vfwork/DINish*/DINish*-Regular.ufo/fontinfo.plist

# Move this to the Makefile...
fontmake --flatten-components DINish-Variable.designspace -o variable-cff2
statmake --stylespace DINish-Variable.stylespace --designspace DINish-Variable.designspace variable_otf/DINish-Variable-VF.otf
fontmake --flatten-components DINish-Variable.designspace -o variable
statmake --stylespace DINish-Variable.stylespace --designspace DINish-Variable.designspace variable_ttf/DINish-Variable-VF.ttf
woff2_compress variable_ttf/DINish-Variable-VF.ttf
mkdir -p fonts/ttf/variable fonts/otf/variable fonts/woff2/variable
cp variable_ttf/DINish-Variable-VF.ttf fonts/ttf/variable/DINish$preview'[slnt,wdth,wght]'.ttf
cp variable_ttf/DINish-Variable-VF.woff2 fonts/woff2/variable/DINish$preview'[slnt,wdth,wght]'.woff2
cp variable_otf/DINish-Variable-VF.otf fonts/otf/variable/DINish$preview'[slnt,wdth,wght]'.otf
make all fontbakery
