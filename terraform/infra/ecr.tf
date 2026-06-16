resource "aws_ecr_repository" "flask-app" {
  name                 = "${var.app_name}-flask"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.app_name}-flask"
  }
}

output "ecr_repository_url" {
  description = "ECR repository URL for Flask app"
  value       = aws_ecr_repository.flask-app.repository_url
}