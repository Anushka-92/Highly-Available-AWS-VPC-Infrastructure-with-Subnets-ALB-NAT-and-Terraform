resource "aws_subnet" "public_1a" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.1.0/24"
availability_zone = "ap-southeast-1a"
map_public_ip_on_launch = true
tags = { Name = "Public-1A" }
}


resource "aws_subnet" "private_1a" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.2.0/24"
availability_zone = "ap-southeast-1a"
tags = { Name = "Private-1A" }
}


resource "aws_subnet" "public_1b" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.3.0/24"
availability_zone = "ap-southeast-1b"
map_public_ip_on_launch = true
tags = { Name = "Public-1B" }
}


resource "aws_subnet" "private_1b" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.4.0/24"
availability_zone = "ap-southeast-1b"
tags = { Name = "Private-1B" }
}