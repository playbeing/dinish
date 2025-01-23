#!/bin/sh

# The features.fea of DINish-Regular is the master. Synchronize
# changes to the other masters

set -e
cd sources

for f in DINish DINishCondensed DINishExpanded
do
    masterdir=DINish/DINish-Regular.ufo
    for s in Regular Bold
    do
        dir=$f/$f-$s.ufo
        if [ $dir != $masterdir ]; then
            if cmp -s $masterdir/features.fea $dir/features.fea; then
                :
            else
                echo "Synchronizing $dir/features.fea"
                cp $masterdir/features.fea $dir/
            fi
        fi
    done
done
