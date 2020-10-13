#!/bin/sh

aws ec2 describe-instances

#todo:
# print full instance info json, do not have to close manually using :q
# filter by instance name tag and print out only relevant information like instance id, name, instance state (running, stopping, stopped, ...) --> do this using jq
# flag --full-info still prints the complete json
#aws ec2 describe-instances --instance-ids $INSTANCE_ID

