#!/bin/bash
set -e

DIR="$(dirname $0)"

$DIR/ec2_launch.sh
sleep 30
ssh ec2 "bash -s" < $DIR/ec2_linux_start.sh
