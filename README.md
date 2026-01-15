
# Highly Available AWS VPC Infrastructure with Terraform

## Architecture Overview

### Key Components
- Custom AWS VPC (10.0.0.0/16)
- Multi-AZ Public and Private Subnets
- Internet Gateway & NAT Gateway
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG) for Web Tier
- EC2 Instances (Web & DB)
- CloudWatch Monitoring & VPC Flow Logs
- Terraform for IaC

---

## Logical Architecture

```

                  INTERNET
                             |
                     +----------------+
                     |  Internet GW   |
                     +----------------+
                             |
               +-----------------------------+
               |  Application Load Balancer  |
               |           (ALB)             |
               +-----------------------------+
                     |               |
            ----------               ----------
            |                                  |
+----------------------+        +----------------------+
| Public Subnet AZ-1   |        | Public Subnet AZ-2   |
| 10.0.1.0/24          |        | 10.0.3.0/24          |
| WebServer-1          |        | WebServer-2          |
| Auto-Assign Public   |        | Auto-Assign Public   |
+----------------------+        +----------------------+
            |                                  |
---------------------------------------------------------
                VPC (10.0.0.0/16)
---------------------------------------------------------
            |                                  |
+----------------------+        +----------------------+
| Private Subnet AZ-1  |        | Private Subnet AZ-2  |
| 10.0.2.0/24          |        | 10.0.4.0/24          |
| DB Server            |        | (Optional Replica)   |
| No Public IP         |        |                      |
+----------------------+        +----------------------+
            |
     +----------------------+
     |     NAT Gateway      |
     |   (Public Subnet)    |
     +----------------------+
            |
     Internet (for updates only)

```

**Optional:**  
Laptop → Bastion Host → Private Subnets

---

## Network Design

| Component        | CIDR Block      | Availability Zone |
|------------------|-----------------|-------------------|
| VPC              | 10.0.0.0/16     | ap-southeast-1    |
| Public Subnet    | 10.0.1.0/24     | ap-southeast-1a  |
| Private Subnet   | 10.0.2.0/24     | ap-southeast-1a  |
| Public Subnet    | 10.0.3.0/24     | ap-southeast-1b  |
| Private Subnet   | 10.0.4.0/24     | ap-southeast-1b  |

---

## 🔐 Security Implementation
- Public EC2 instances allow HTTP (80) from the internet
- SSH (22) restricted to trusted IP only
- Database server deployed in private subnet
- DB access allowed only from Web Tier Security Group
- No public IPs assigned to private instances

---

## Auto Scaling Group (Web Tier)

### Why Auto Scaling?
- Handles traffic spikes automatically
- Improves availability and fault tolerance
- Reduces cost during low traffic

### Auto Scaling Flow
- Launch Template defines EC2 configuration
- ASG spans multiple AZs
- ALB distributes traffic to ASG instances
- CloudWatch monitors CPU utilization
- ASG scales out/in automatically

---

## 📊 Monitoring & Logging
- EC2 Detailed Monitoring enabled
- CloudWatch Alarms for CPU utilization
- VPC Flow Logs for network traffic analysis

---

## Testing Scenarios
- Stop one EC2 → traffic continues via ALB
- Increase CPU load → ASG launches new instance
- Remove NAT route → private instances lose internet access
- Restrict Security Group → DB becomes inaccessible from public

---

## Cleanup

terraform destroy



## 📌 Future Enhancements

* I can replace EC2 DB with Amazon RDS (Multi-AZ)
* I can add HTTPS using ACM
* CI/CD pipeline using GitHub Actions
* Convert Terraform into reusable modules


---
