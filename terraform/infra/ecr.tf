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

resource "null_resource" "docker_push" {
  triggers = {
    ecr_repo = aws_ecr_repository.flask-app.repository_url
  }

  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.flask-app.repository_url}
      docker build -t ${aws_ecr_repository.flask-app.repository_url}:latest ${path.module}/../../
      docker push ${aws_ecr_repository.flask-app.repository_url}:latest
    EOF
  }

  depends_on = [aws_ecr_repository.flask-app]
}

output "ecr_repository_url" {
  description = "ECR repository URL for Flask app"
  value       = aws_ecr_repository.flask-app.repository_url
}