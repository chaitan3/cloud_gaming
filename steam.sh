#!/bin/bash
#
# Setup a driver for hardware streaming support with Intel graphics compatible
# with Steam, and launch Stream with an environment variable set to use it.
# This is a workaround for
# https://github.com/ValveSoftware/steam-for-linux/issues/5339

# This version of the i965 VA driver supports at least Skylake's Iris Graphics 540.
# I tried i965-va-driver_1.8.3-1ubuntu1_i386.deb, but that fails to load with
#   libva error: /home/toojays/.local/share/Steam/ubuntu12_32/steam-runtime/i386/../pinned_libs_32/i965_drv_video.so has no function __vaDriverInit_0_32
# Get it from any Ubuntu mirror, e.g. 
DRIVER_PACKAGE=$(dirname $0)/i965-va-driver_1.7.0-1_i386.deb
DRIVER_URL="http://mirror.internode.on.net/pub/ubuntu/pool/universe/i/intel-vaapi-driver/i965-va-driver_1.7.0-1_i386.deb"
if [ ! -f $DRIVER_PACKAGE ]; then
    wget $DRIVER_URL -O $DRIVER_PACKAGE
fi

# You probably don't need to change these two.
#TARGET_ROOT=$HOME/.local/share/Steam/ubuntu12_32/steam-runtime/i386
TARGET_ROOT=$HOME/.steam/ubuntu12_32/steam-runtime/i386
PIN_DIR=$TARGET_ROOT/../pinned_libs_32

# Unpack the i965 VAAPI drivers.
dpkg --vextract $DRIVER_PACKAGE $TARGET_ROOT

# "Pin" the old versions of VAAPI bundled with Steam. This tells Steam to prefer
# these libraries over any which are in the system's default library search
# path.
ln -sf --target-directory $PIN_DIR $TARGET_ROOT/usr/lib/i386-linux-gnu/{libva.so.1,libva-x11.so.1}

# Tell libva how to find to i965_drv_video.so when we run steam.
LIBVA_DRIVERS_PATH=$TARGET_ROOT/usr/lib/i386-linux-gnu/dri steam
