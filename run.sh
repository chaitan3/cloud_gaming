#!/bin/bash
DIR="$(dirname $0)"

#ssh ec2 "bash -s" < $DIR/ec2_linux_install.sh
ssh ec2 "bash -s" < $DIR/ec2_linux_start.sh
