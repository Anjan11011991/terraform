# variables.tf

# VPC Configuration
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Availability Zone for the subnets"
  type        = string
  default     = "us-east-1a"  # Change this based on your region
}

# Public Subnet Configuration
variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Private Subnet Configuration
variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Internet Gateway (True/False)
variable "create_internet_gateway" {
  description = "Whether to create an internet gateway"
  type        = bool
  default     = true
}

# NAT Gateway Configuration
variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = true
}

# Region for AWS
variable "aws_region" {
  description = "AWS region for the VPC and subnets"
  type        = string
  default     = "us-east-1"
}
