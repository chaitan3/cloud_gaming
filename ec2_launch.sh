#!/bin/bash
set -e

source $(dirname $0)/config

# Note 1: comment/uncomment "instance-market-options" for ondemand/spot instances
#         additional options for spot instances: BlockDurationMinutes, ValidUntil

# Note 2: comment/uncomment "block-device-mappings" for not having/having a persistent ebs volume for storing games
#         use SnapshotId to add a prevoiously created volume

EC2_NEW_VOLUME="--block-device-mappings \"DeviceName=/dev/sdb,Ebs={DeleteOnTermination=false,VolumeSize=100,VolumeType=gp2}\"" 

if [ ! -z "${EC2_VOLUME}" ]; then
    EC2_NEW_VOLUME=""
fi

aws ec2 run-instances \
    --count 1 \
    --instance-type ${EC2_INSTANCE_TYPE} \
    --image-id ${EC2_AMI} \
    --key-name ${EC2_KEY_NAME} \
    --security-group-ids ${EC2_SECURITY_GROUP} \
    --instance-initiated-shutdown-behavior terminate \
    --instance-market-options "MarketType=spot,SpotOptions={MaxPrice=${EC2_MAX_PRICE},SpotInstanceType=one-time,InstanceInterruptionBehavior=terminate}" \
    ${EC2_NEW_VOLUME} \
;
sleep 10

EC2_IP=$(aws ec2 describe-instances | \
    python3 -c "import sys,json;print(json.load(sys.stdin)['Reservations'][-1]['Instances'][0]['PublicDnsName'])")
EC2_INSTANCE=$(aws ec2 describe-instances | \
    python3 -c "import sys,json;print(json.load(sys.stdin)['Reservations'][-1]['Instances'][0]['InstanceId'])")

if [ ! -z "${EC2_VOLUME}" ]; then
    aws ec2 attach-volume --volume-id ${EC2_VOLUME} --instance-id ${EC2_INSTANCE} --device /dev/sdf
fi

mkdir -p $(dirname ${EC2_CONFIG})
echo "
Host ec2
    User ubuntu
    StrictHostKeyChecking no
    HostName ${EC2_IP}
    IdentityFile ${EC2_KEYFILE}
" > ${EC2_CONFIG}
