resource "aws_route53_record" "phonebook" {
  zone_id = "Z053955035MJMAR5SBVVW"
  name    = "phonebook.kenanilhan.com"
  type    = "A"

  alias {
    name                   = aws_lb.app-alb.dns_name
    zone_id                = aws_lb.app-alb.zone_id
    evaluate_target_health = true
  }
}