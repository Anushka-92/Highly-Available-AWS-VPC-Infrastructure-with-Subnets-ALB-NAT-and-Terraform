# Highly Available AWS VPC Infrastructure with Terraform

## 📌 Project Overview

This project demonstrates a **production-grade AWS infrastructure** designed using best practices for **high availability, security, and scalability**. The infrastructure is provisioned using **Terraform (Infrastructure as Code)** and follows a **public–private subnet architecture** across multiple Availability Zones.

The project simulates a real-world web application deployment with a scalable web tier and a secured private database tier.

---

## 🏗️ Architecture Overview

**Key Components:**

* Custom AWS VPC (10.0.0.0/16)
* Multi-AZ Public and Private Subnets
* Internet Gateway & NAT Gateway
* Application Load Balancer (ALB)
* Auto Scaling Group (ASG) for Web Tier
* EC2 Instances (Web & DB)
* CloudWatch Monitoring & VPC Flow Logs
* Terraform for IaC

### Logical Architecture
```
                     INTERNET
                        |
                +----------------+
                |  Internet GW   |
                +----------------+
                        |
              +-----------------------+
              | Application Load      |
              | Balancer (ALB)        |
              +-----------------------+
                  |              |
          ----------              ----------
          |                                   |
+---------------------+         +---------------------+
| Public Subnet AZ-1  |         | Public Subnet AZ-2  |
| 10.0.1.0/24         |         | 10.0.3.0/24         |
| WebServer-1         |         | WebServer-2         |
| Auto-Assign Public  |         | Auto-Assign Public  |
+---------------------+         +---------------------+
          |                                   |
          |                                   |
---------------------- VPC (10.0.0.0/16) ----------------------

          |                                   |
+---------------------+         +---------------------+
| Private Subnet AZ-1 |         | Private Subnet AZ-2 |
| 10.0.2.0/24         |         | 10.0.4.0/24         |
| DB Server           |         | (Optional Replica) |
| No Public IP        |         |                     |
+---------------------+         +---------------------+
          |
          |
     +----------------+
     | NAT Gateway    |
     | (Public Subnet)|
     +----------------+
          |
       Internet (for updates only)

Optional:
Laptop → Bastion Host → Private Subnets
```

---

## 🧱 Network Design

| Component      | CIDR        | AZ              |
| -------------- | ----------- | --------------- |
| VPC            | 10.0.0.0/16 | ap-southeast-1  |
| Public Subnet  | 10.0.1.0/24 | ap-southeast-1a |
| Private Subnet | 10.0.2.0/24 | ap-southeast-1a |
| Public Subnet  | 10.0.3.0/24 | ap-southeast-1b |
| Private Subnet | 10.0.4.0/24 | ap-southeast-1b |

---

## 🔐 Security Implementation

* Public EC2 instances allow HTTP (80) from the internet
* SSH (22) restricted to **trusted IP only**
* Database server deployed in **private subnet**
* DB access allowed **only from Web Tier Security Group**
* No public IPs assigned to private instances

---

## ⚙️ Auto Scaling Group (Web Tier)

### Why Auto Scaling?

* Handles traffic spikes automatically
* Improves availability and fault tolerance
* Reduces cost during low traffic

### Auto Scaling Flow

1. Launch Template defines EC2 configuration
2. ASG spans **multiple AZs**
3. ALB distributes traffic to ASG instances
4. CloudWatch monitors CPU utilization
5. ASG scales out/in automatically

---

## 🚀 Terraform – Auto Scaling Group Configuration

### Launch Template

```hcl
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt"
  image_id      = "ami-xxxxxxxx"   # Amazon Linux 2
  instance_type = "t2.micro"

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install httpd -y
echo "Hello from Auto Scaling Instance" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF
  )

  network_interfaces {
    security_groups = [aws_security_group.web_sg.id]
    associate_public_ip_address = true
  }
}
```

---

### Auto Scaling Group

```hcl
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity = 2
  max_size         = 4
  min_size         = 1

  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "ASG-WebServer"
    propagate_at_launch = true
  }
}
```

---

### Scaling Policy

```hcl
resource "aws_autoscaling_policy" "cpu_scale_out" {
  name                   = "cpu-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
```

---

## 📊 Monitoring & Logging

* EC2 Detailed Monitoring enabled
* CloudWatch Alarms for CPU utilization
* VPC Flow Logs for network traffic analysis

---

## 🧪 Testing Scenarios

* Stop one EC2 → traffic continues via ALB
* Increase CPU load → ASG launches new instance
* Remove NAT route → private instances lose internet access
* Restrict Security Group → DB becomes inaccessible from public

---

## 🧹 Cleanup

```bash
terraform destroy
```
---

## 📌 Future Enhancements

* I can replace EC2 DB with Amazon RDS (Multi-AZ)
* Add HTTPS using ACM
* CI/CD pipeline using GitHub Actions
* Convert Terraform into reusable modules

---
