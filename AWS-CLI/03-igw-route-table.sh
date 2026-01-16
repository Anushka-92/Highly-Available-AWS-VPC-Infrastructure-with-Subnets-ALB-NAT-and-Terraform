#!/bin/bash

aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway \
  --internet-gateway-id <IGW_ID> \
  --vpc-id <VPC_ID>

aws ec2 create-route-table --vpc-id <VPC_ID>

aws ec2 create-route \
  --route-table-id <RT_ID> \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id <IGW_ID>
