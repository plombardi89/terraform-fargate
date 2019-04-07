variable "name_prefix" {
  description = "A prefix used to name managed resources"
}

variable "vpc_id" {
  description = "ID of the VPC where the load balancer operates"
}

variable "subnet_ids" {
  description = "A list of subnet IDs where load balancers can be provisioned"
  type        = "list"
}

variable "type" {
  description = "Type of load balancer to provision (network or application)"
}

variable "access_logs_prefix" {
  description = "Prefix for access log bucket items"
  default     = ""
}

variable "access_logs_bucket" {
  description = "Name of S3 bucket for load balancer access logs"
  default     = ""
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application (Default: 60)"
  default     = 60
}

variable "tags" {
  description = "A map of tags assigned to managed resources"
  type        = "map"
  default     = {}
}
