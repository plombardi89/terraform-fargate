variable "name" {
  description = "Common name for the VPC"
}

variable "cidr_block" {
  description = "CIDR block used for IP address allocation in the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use for this"
  type        = "list"
}

variable "tags" {
  description = "A map of tags assigned to managed resources"
  type        = "map"
  default     = {}
}
