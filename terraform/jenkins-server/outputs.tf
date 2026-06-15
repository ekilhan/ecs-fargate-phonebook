output "jenkins_url" {
  description = "URL to access Jenkins server web interface on port 8080"
  value       = "http://${aws_eip.js-eip.public_ip}:8080"
}