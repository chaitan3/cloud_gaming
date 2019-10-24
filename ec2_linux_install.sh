#!/bin/bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y build-essential pkgconfig
sudo apt install -y xorg xterm mesa-utils i3 pulseaudio
sudo apt install -y libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libglvnd-dev

wget https://s3.amazonaws.com/nvidia-gaming/NVIDIA-Linux-x86_64-435.22-grid.run
chmod +x *.run 
sudo ./*.run -q -a -n -X -s

sudo rmmod nvidia_drm nvidia_modeset nvidia

cat << EOF | sudo tee -a /etc/nvidia/gridd.conf
vGamingMarketplace=2
EOF

sudo wget -O /etc/nvidia/GridSwCert.txt "https://s3.amazonaws.com/nvidia-gaming/GridSwCert-Linux.cert"

cat << EOF | sudo tee /etc/X11/xorg.conf
# manual X11 config
Section "DRI"
	Mode 0666
EndSection

Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "Tesla T4"
    BusID          "PCI:00:30:0"
EndSection
EOF

cat << EOF | sudo tee ~/.vnc_hosts
+127.0.0.1
-
EOF

nvidia-smi

wget -O steam.deb https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo dpkg -i steam.deb
sudo apt install -f -y

mkdir -p ~/.config/i3
cp /etc/i3/config ~/.config/i3/config
sed -i '$d' ~/.config/i3/config

wget https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.9.0.x86_64.tar.gz
tar xf download*
cd tiger*
sudo rsync -aRv ./usr /


