#! /bin/sh


if [ $# -ne 1 ]; then
    echo "help : $(basename $0) [device_path]"
    echo "Usage:"
    echo "      $(basename $0) /dev/sda"
    echo ""
exit
exit
    exit 1
fi

DRIVE=$1

#erasing the first 1024*1024= 1MB
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo CYLINDERS - $CYLINDERS

#{
#echo ,9,0x0C,*
#echo ,,,-
#} | sfdisk --DOS -heads 255 --sectors 63 --cyclinders $CYLINDERS $DRIVE
#

#sfdisk -u S $DRIVE << EOF
#63,144522,0x0C,*
#,,,-

#5500000 -> means 2.6GB
sfdisk -u S $DRIVE << EOF
63,5500000,0x0C,*
,,,-
EOF

ls /dev/sd*

if [ -b ${DRIVE}1 ]; then
    mkfs.vfat -F 32 -n "kernel" ${DRIVE}1
else
    if [ -b ${DRIVE}p1 ]; then
        mkfs.vfat -F 32 -n "kernel" ${DRIVE}p1
    else
        echo "Cant find boot partition in /dev"
    fi
fi
 #! /bin/sh
if [ -b ${DRIVE}2 ]; then
    mkfs.ext4  -L "romfs" ${DRIVE}2
else
    if [ -b ${DRIVE}p2 ]; then
        mke2fs -j -L "romfs" ${DRIVE}p2
    else
        echo "Cant find rootfs partition in /dev"
    fi
fi

