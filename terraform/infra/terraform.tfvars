aws_region = "us-east-1"

vpc_id = "vpc-08477c96022d400ae"

public_subnet_ids = [
  "subnet-04240f6a213616d20",  # us-east-1a
  "subnet-0ff937b76b26a0f07",  # us-east-1c
  "subnet-075dfa34a175a8ce6"   # us-east-1b
]

private_subnet_ids = [
  "subnet-077c21940e553db88",  # us-east-1a
  "subnet-04773ef2e777123d3",  # us-east-1c
  "subnet-0dab39d1e8f236a6a"   # us-east-1b
]

app_name         = "phonebook"
environment      = "dev"

# ECS
flask_image_uri = "346690756498.dkr.ecr.us-east-1.amazonaws.com/phonebook-flask:latest"
flask_cpu        = 256
flask_memory     = 512

# RDS
db_name          = "phonebook"
db_username      = "admin"
db_password      = "changeme123!"
db_instance_class = "db.t3.micro"