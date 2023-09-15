# Output the DNS name of the load balancer
output "lb_dns" {
  value = aws_elb.CAPSTONE.dns_name
}
