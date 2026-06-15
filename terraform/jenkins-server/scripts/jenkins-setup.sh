#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

# System update
dnf update -y

# Install Java 21
dnf install -y java-21-amazon-corretto

# Add Jenkins repository and import GPG key
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install and enable Jenkins
dnf install -y jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Git
dnf install -y git

# Install and enable Docker
dnf install -y docker
systemctl enable docker
systemctl start docker

# Add jenkins and ec2-user to docker group
usermod -aG docker jenkins
usermod -aG docker ec2-user

# Update AWS CLI
dnf install -y awscli