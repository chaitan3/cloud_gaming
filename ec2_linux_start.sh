#!/bin/bash

run_bg () {
    nohup $* > /dev/null < /dev/null 2>&1 &
}

run_bg sudo X :0 
sleep 3

export DISPLAY=:0
run_bg i3
run_bg xterm 
run_bg x0vncserver -SecurityTypes None -rfbport 5900 -hostsfile ~/.vnc_hosts -geometry 1920x1080+0+0 
sleep 1
