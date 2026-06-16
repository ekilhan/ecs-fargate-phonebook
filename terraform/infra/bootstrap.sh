#!/bin/bash
set -e

AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="346690756498"
ECR_REPO="phonebook-flask"
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO"

# Navigate to repo root to access Dockerfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd $REPO_ROOT

echo "==> Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

echo "==> Checking if ECR repository exists..."
aws ecr describe-repositories --repository-names $ECR_REPO --region $AWS_REGION 2>/dev/null || \
  aws ecr create-repository --repository-name $ECR_REPO --region $AWS_REGION

echo "==> Building Docker image..."
docker build -t $ECR_URI:latest .

echo "==> Pushing image to ECR..."
docker push $ECR_URI:latest

echo "==> Done! Image pushed: $EC_URI:latest"