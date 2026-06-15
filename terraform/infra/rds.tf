resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "${var.app_name}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.app_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier           = "${var.app_name}-mysql"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  allocated_storage    = 20
  storage_type         = "gp2"
  skip_final_snapshot  = true
  publicly_accessible  = false

  tags = {
    Name = "${var.app_name}-mysql"
  }
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.mysql.endpoint
}