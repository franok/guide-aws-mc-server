#!/bin/sh

INSTANCE_ID=$1
PUBLIC_IP='unassigned'
MC_SERVER_PORT=25565


if [ -z "$INSTANCE_ID" ]; then
  echo "Error: no instance-id provided! Usage: './launch-ec2.sh i-xxxxxxxxxxxxxxxxx'."
  exit 1
fi

aws ec2 start-instances --instance-ids $INSTANCE_ID

printf '\n'
printf 'Waiting 15 seconds for public IPv4 address...\n\n'
sleep 15 # wait until a public ipv4 is assigned to the ec2 instance-ids


#command -v jq #exitcode 0 use jq, else grep
if [ -x "$(command -v jq)" ]; then
  PUBLIC_IP=`aws ec2 describe-instances --instance-id $INSTANCE_ID | jq -r '.Reservations[0].Instances[0].PublicIpAddress'`
else
  printf 'Warning: jq not found. Trying fallback to grep.\n'
  PUBLIC_IP=`aws ec2 describe-instances --instance-id $INSTANCE_ID | grep -i publicip`
fi

echo "Current IPv4 address of ec2-instance '$INSTANCE_ID' is:"
echo $PUBLIC_IP
printf '\n'
echo "Minecraft Server reachable within the next 1-2 minutes under:"
echo "$PUBLIC_IP:$MC_SERVER_PORT"


