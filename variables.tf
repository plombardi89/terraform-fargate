variable "region" {
  description = "AWS region where infrastructure is managed by Terraform"
  default     = "us-east-2"
}

variable "profile_name" {
  description = "Name of the AWS shared credentials profile"
  default     = "default"
}

variable "application" {
  description = "Name of the application"
}

variable "task_container_image" {
  description = "A container image to run"
}

variable "task_container_port" {
  description = "Port used by the container to expose itself"
  default     = 8080
}

variable "tags" {
  description = "Zero or more key/value pairs to assign to managed resources"
  type        = "map"
  default     = {}
}
