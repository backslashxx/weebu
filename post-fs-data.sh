#!/usr/bin/env sh
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
MODDIR="${0%/*}"
modid="my_ringtone"

# make sure $MODDIR/skip_mount exists!
# this way ksu wont mount it
# we handle the mounting ourselves
[ ! -f $MODDIR/skip_mount ] && touch $MODDIR/skip_mount

[ -w /mnt ] && basefolder=/mnt
[ -w /mnt/vendor ] && basefolder=/mnt/vendor

# we mimic vendor mounts like, my_bigball
mkdir $basefolder/$modid

cd $MODDIR
# remove symlinks, remove system/product -> ../product shit
find ./ -maxdepth 2 -type l -delete

for i in $(ls -d */*/*/*); do
	mkdir -p $basefolder/$modid/$i
	mount --bind $MODDIR/$i $basefolder/$modid/$i
	mount -t overlay -o "lowerdir=$basefolder/$modid/$i:/$i" overlay /$i
	${SUSFS_BIN} add_sus_mount /$i
done
