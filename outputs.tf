output "vpc_id" {
  value = "${module.network.id}"
}

output "vpc_cidr_block" {
  value = "${module.network.cidr_block}"
}

output "public_subnet_ids" {
  value = "${module.network.public_subnet_ids}"
}

output "load_balancer_dns_name" {
  value = "${module.load_balancer.dns_name}"
}

output "load_balancer_zone_id" {
  value = "${module.load_balancer.zone_id}"
}

output "access_logs_bucket" {
  value = "${aws_s3_bucket.access_logs.id}"
}

output "cluster_id" {
  value = "${aws_ecs_cluster.cluster.id}"
}

output "cluster_arn" {
  value = "${aws_ecs_cluster.cluster.arn}"
}

output "service_arn" {
  value = "${module.app.service_arn}"
}

output "service_security_group_id" {
  value = "${module.app.service_security_group_id}"
}

output "target_group_arn" {
  value = "${module.app.target_group_arn}"
}

output "task_role_arn" {
  value = "${module.app.task_role_arn}"
}

output "task_role_name" {
  value = "${module.app.task_role_name}"
}
