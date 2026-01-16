#!/bin/bash

# Web SG
aws ec2 create-security-group \
  --group-name WebSG \
  --description "Web Server SG" \
  --vpc-id <VPC_ID>

aws ec2 authorize-security-group-ingress \
  --group-id <WEB_SG_ID> \
  --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --group-id <WEB_SG_ID> \
  --protocol tcp --port 80 --cidr 0.0.0.0/0
