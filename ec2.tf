data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Public Subnet: 1"]
  }

  depends_on = [aws_route_table_association.public_subnet_route_association]
}

resource "aws_instance" "ec2_public" {
  ami           = "ami-03054abaec0c63e6e"
  instance_type = "t3.micro"
  associate_public_ip_address = true

  tags = {
    "Name" = "Ec2 public subnet 1"
  }

  key_name               = "aws_key"
  subnet_id              = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_vpc_eu_central_1.id]
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "public key"
}

output "ssh_info" {
  value = format("%s%s",
  "ssh -i /home/baggy/.ssh/aws_key ec2-user@",
  aws_instance.ec2_public.public_dns
  )
}