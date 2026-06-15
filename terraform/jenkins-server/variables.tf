variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "erhanskey"
}
variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be launched"
  type        = string
  default     = "vpc-04b53f2daf82d4957"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0521cb2d60cfbb1a6"
}