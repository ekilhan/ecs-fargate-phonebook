variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "app_name" {
  default = "phonebook"
}

variable "environment" {
  default = "dev"
}

# ECS
variable "flask_image_uri" {}
variable "flask_cpu" {
  default = 256
}
variable "flask_memory" {
  default = 512
}

# RDS
variable "db_name" {
  default = "phonebook"
}
variable "db_username" {
  default = "admin"
}
variable "db_password" {
  sensitive = true
}
variable "db_instance_class" {
  default = "db.t3.micro"
}
