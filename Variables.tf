variable "aws_region" {
default = "ap-southeast-1"
}


variable "vpc_cidr" {
default = "10.0.0.0/16"
}


variable "my_ip" {
description = "Your public IP for SSH access"
}