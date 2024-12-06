#!/usr/bin/env sh
MODDIR="${0%/*}"
# we mimic vendor mounts like, my_bigball, vendor_dklm, mi_ext
# whatever use what you want provided here is just an example
modid="my_ringtone"
# susfs usage is optional currently but heres how you can utilize it
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs

# make sure $MODDIR/skip_mount exists!
# this way ksu wont mount it
# we handle the mounting ourselves
[ ! -f $MODDIR/skip_mount ] && touch $MODDIR/skip_mount

# this is a fast lookup for a writable dir
# these tends to be always available
[ -w /mnt ] && basefolder=/mnt
[ -w /mnt/vendor ] && basefolder=/mnt/vendor

mkdir $basefolder/$modid
${SUSFS_BIN} add_sus_path $basefolder/$modid

cd $MODDIR
# remove symlinks, remove system/product -> ../product shit
# this is optional, but for the purposes of this demo module, I DO NOT need this.
# comment this out for something like iconify, credits to ham1do
find ./ -maxdepth 2 -type l -delete

for i in $(ls -d */*); do
	mkdir -p $basefolder/$modid/$i
	mount --bind $MODDIR/$i $basefolder/$modid/$i
	mount -t overlay -o "lowerdir=$basefolder/$modid/$i:/$i" overlay /$i
	${SUSFS_BIN} add_sus_mount /$i
done
