# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"

  tags = {
    Name = "${var.app_name}-cluster"
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs-task-execution-role" {
  name = "${var.app_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-policy" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "flask" {
  family                   = "${var.app_name}-flask"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.flask_cpu
  memory                   = var.flask_memory
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn

  container_definitions = jsonencode([{
    name      = "flask-app"
    image     = var.flask_image_uri
    essential = true

    portMappings = [{
      containerPort = 5000
      protocol      = "tcp"
    }]

    environment = [
    {
    name  = "MYSQL_HOST"
    value = aws_db_instance.mysql.address
    },
    {
    name  = "MYSQL_USER"
    value = var.db_username
    },
    {
    name  = "MYSQL_PASSWORD"
    value = var.db_password
    },
    {
    name  = "MYSQL_DB"
    value = var.db_name
    },
    {
    name  = "MYSQL_PORT"
    value = "3306"
    }
]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.app_name}-flask"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "flask" {
  name              = "/ecs/${var.app_name}-flask"
  retention_in_days = 7

  tags = {
    Name = "${var.app_name}-flask-logs"
  }
}

# ECS Service
resource "aws_ecs_service" "flask" {
  name            = "${var.app_name}-flask-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.flask.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask-tg.arn
    container_name   = "flask-app"
    container_port   = 5000
  }

    depends_on = [
    aws_lb_listener.https,
    aws_iam_role_policy_attachment.ecs-task-execution-policy
  ]

  tags = {
    Name = "${var.app_name}-flask-service"
  }
}