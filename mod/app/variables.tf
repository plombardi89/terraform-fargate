variable "application" {
  description = "Name of the application"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  description = "List of public subnets inside of the VPC"
  type        = "list"
}

variable "cluster_id" {
  description = "ID of the ECS cluster"
}

variable "task_container_image" {
  description = "The image used to start a container"
}

variable "load_balancer_arn" {
  description = "ARN of the load balancer"
}

variable "load_balancer_security_group_id" {
  description = "ID of the load balancer security group"
}

variable "load_balancer_deregistration_delay" {
  description = "Time to deregister a backend from the load balancer target group"
  default     = 300
}

variable "replicas" {
  description = "The number of instances of the task definitions to place and keep running"
  default     = "1"
}

variable "task_container_assign_public_ip" {
  description = "Assigned public IP to the container"
  default     = "false"
}

variable "task_container_port" {
  description = "Port that the container exposes"
}

variable "task_container_protocol" {
  description = "Protocol that the container exposes"
  default     = "HTTP"
}

variable "task_definition_cpu" {
  description = "Amount of CPU to reserve for the task"
  default     = "256"
}

variable "task_definition_memory" {
  description = "The soft limit (in MiB) of memory to reserve for the container"
  default     = "512"
}

variable "task_container_command" {
  description = "The command that is passed to the container"
  type        = "list"
  default     = []
}

variable "task_container_environment" {
  description = "The environment variables to pass to a container"
  type        = "map"
  default     = {}
}

variable "log_retention_in_days" {
  description = "Number of days the logs will be retained in CloudWatch"
  default     = "30"
}

variable "health_check" {
  description = "A health block containing health check settings for the target group. Overrides the defaults"
  type        = "map"
}

variable "health_check_grace_period_seconds" {
  default     = "300"
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown"
}

variable "tags" {
  description = "A map of tags assigned to managed resources"
  type        = "map"
  default     = {}
}

variable "deployment_minimum_healthy_percent" {
  default     = "50"
  description = "Minimum of the number of running tasks that must remain running and healthy in a service during a deployment"
}

variable "deployment_maximum_percent" {
  default     = "200"
  description = "Maximum number of running tasks that can be running in a service during a deployment"
}
