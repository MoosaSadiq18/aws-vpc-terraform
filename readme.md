# AWS VPC with Terraform

Just built an AWS VPC in `eu-central-1` using Terraform.

It includes:
- A VPC with public and private subnets.
- Ec2 instance in the public subnet.
- An Internet Gateway for public subnet internet access.
- NAT Gateways for outbound internet access from private subnets.
- Route tables and subnet associations to control network traffic.

## Commands

```bash
terraform init
terraform plan
terraform apply