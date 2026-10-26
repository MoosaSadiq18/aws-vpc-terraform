resource "aws_security_group" "sg_vpc_eu_central_1" {

  //rules for outgoing traffic
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = -1
      self             = false
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
    }
  ]

  //rules for incoming traffic
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      self             = false
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
    }
  ]

  vpc_id     = aws_vpc.vpc_project.id
  depends_on = [aws_vpc.vpc_project]

  tags = {
    "Name" = "Ec2 public security group"
  }

}