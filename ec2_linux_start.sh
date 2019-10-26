#!/bin/bash
set -e

RESOLUTION=1920x1080
DEVICE=/dev/nvme0n1

run_bg () {
    nohup $* > /dev/null < /dev/null 2>&1 &
    sleep 0.1
}

run_bg sudo X :0 
sleep 3

export DISPLAY=:0
xrandr --output DVI-D-0 --mode $RESOLUTION
sleep 1
run_bg i3
run_bg xterm 
run_bg start-pulseaudio-x11
run_bg x0vncserver -SecurityTypes None -rfbport 5900 -hostsfile ~/.vnc_hosts -geometry $RESOLUTION+0+0
sleep 1

sudo chmod 666 /dev/uinput

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk ${DEVICE}
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
    # default, extend partition to end of disk
  w # write the partition table
  q # and we're done
EOF
sleep 5
sudo mkfs.ext4 ${DEVICE}p1
sudo mount ${DEVICE}p1 /mnt
sudo chown ubuntu:ubuntu -R /mnt
