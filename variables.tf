variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block for my project"
  default     = "10.0.0.0/16"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "public subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "private subnet"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "aws_availability_zone" {
  type        = list(string)
  description = "avl zones"
  default     = ["eu-central-1a", "eu-central-1b"]
}