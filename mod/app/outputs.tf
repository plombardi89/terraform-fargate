output "service_arn" {
  description = "ARN of the ECS service"
  value       = "${aws_ecs_service.this.id}"
}

output "target_group_arn" {
  description = "ARN of the ALB target group for this service"
  value       = "${aws_lb_target_group.this.arn}"
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = "${aws_iam_role.task_role.arn}"
}

output "task_role_name" {
  description = "Name of the ECS task role"
  value       = "${aws_iam_role.task_role.name}"
}

output "service_security_group_id" {
  description = "ARN that identifies the service security group"
  value       = "${aws_security_group.this.id}"
}
