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

# Install docker and Jenkins
dnf install -y docker
dnf install -y jenkins

# Add jenkins and ec2-user to docker group
usermod -aG docker jenkins
usermod -aG docker ec2-user

# Enable and start Jenkins 
systemctl enable jenkins
systemctl start jenkins


# Enable and start Docker

systemctl enable docker
systemctl start docker

# Install Git
dnf install -y git


# Update AWS CLI
dnf install -y awscli