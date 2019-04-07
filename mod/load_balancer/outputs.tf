output "arn" {
  description = "ARN of the load balancer"
  value       = "${aws_lb.this.arn}"
}

output "id" {
  description = "AWS assigned system ID for the load balancer"
  value       = "${aws_lb.this.id}"
}

output "name" {
  description = "Name of the load balancer"
  value       = "${aws_lb.this.name}"
}

output "dns_name" {
  description = "DNS name of the load balancer"
  value       = "${aws_lb.this.dns_name}"
}

output "zone_id" {
  description = "Hosted zone ID of the load balancer"
  value       = "${aws_lb.this.zone_id}"
}

output "security_group_id" {
  description = "The ID of the load balancer security group"
  value       = "${element(concat(aws_security_group.this.*.id, list("")), 0)}"
}
