#!/bin/bash
set -e

source $(dirname $0)/config

aws ec2 run-instances --image-id ${EC2_AMI} --instance-type ${EC2_INSTANCE_TYPE} --key-name ${KEY_NAME} --count 1 --security-group-ids ${EC2_SECURITY_GROUP}
sleep 2

EC2_IP=$(aws ec2 describe-instances | \
    python3 -c "import sys,json;print(json.load(sys.stdin)['Reservations'][-1]['Instances'][0]['PublicDnsName'])")

mkdir -p $(dirname ${EC2_CONFIG})
echo "
Host ec2
    User ubuntu
    HostName ${EC2_IP}
    IdentityFile ${EC2_KEYFILE}
" > ${EC2_CONFIG}
