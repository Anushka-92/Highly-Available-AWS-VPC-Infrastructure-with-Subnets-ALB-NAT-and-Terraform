#!/bin/bash
yum update -y
yum install httpd -y
echo "MyGoogle-2" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
