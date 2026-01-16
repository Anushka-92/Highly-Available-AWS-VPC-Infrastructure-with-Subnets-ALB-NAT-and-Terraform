#!/bin/bash

aws ec2 run-instances \
  --image-id ami-0f5ee92e2d63afc18 \
  --instance-type t2.micro \
  --subnet-id <PUBLIC_SUBNET_ID> \
  --security-group-ids <WEB_SG_ID> \
  --user-data file://user-data.sh
