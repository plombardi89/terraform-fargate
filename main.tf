data "aws_availability_zones" "available" {}
data "aws_elb_service_account" "main" {}

// Generate a random name that we will use to name region scoped resources. This value will be used for the VPC name
// and Fargate cluster name. Further, it will be used as the prefix for other resources.
resource "random_pet" "project_name" {
  length    = 2
  separator = "-"
}

module "network" {
  source = "mod/vpc"

  cidr_block = "10.0.0.0/16"
  name       = "${random_pet.project_name.id}"

  // WARNING: A lot folks use the dynamic value returned from the aws_availability_zones data query. This is DANGEROUS
  //          because the returned count is non-deterministic over time. It is exceedingly unlikely a zone would be
  //          removed from AWS but it is entirely possible a new zone can be added. Folks often compute the subnet
  //          CIDR's in the Terraform config using the cidrsubnet() interpolation function and counting the number of
  //          zones that need subnets. If the number of zones changes then the math changes and this can cause subnet
  //          management conflicts in Terraform. Two options exist here, the first is to explicitly pass zones in and
  //          never rely on dynamic data discovery. The second option is to sort and trim the returned zones to an
  //          always stable size.
  availability_zones = "${slice(sort(data.aws_availability_zones.available.names), 0, 3)}"

  tags = "${var.tags}"
}

resource "aws_s3_bucket" "access_logs" {
  bucket_prefix = "access-logs-"
  tags          = "${var.tags}"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = "${aws_s3_bucket.access_logs.id}"

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.access_logs.bucket}/${var.application}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}

module "load_balancer" {
  source = "mod/load_balancer"

  type               = "application"
  vpc_id             = "${module.network.id}"
  subnet_ids         = "${module.network.public_subnet_ids}"
  name_prefix        = "${var.application}"
  tags               = "${var.tags}"
  access_logs_bucket = "${aws_s3_bucket.access_logs.id}"
  access_logs_prefix = "${var.application}"
}

resource "aws_security_group_rule" "load_balancer_ingress" {
  security_group_id = "${module.load_balancer.security_group_id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_ecs_cluster" "cluster" {
  name = "${random_pet.project_name.id}"
  tags = "${var.tags}"
}

module "app" {
  source = "mod/app"

  application       = "${var.application}"
  public_subnet_ids = "${module.network.public_subnet_ids}"

  cluster_id = "${aws_ecs_cluster.cluster.id}"
  vpc_id     = "${module.network.id}"

  load_balancer_arn                  = "${module.load_balancer.arn}"
  load_balancer_security_group_id    = "${module.load_balancer.security_group_id}"
  load_balancer_deregistration_delay = 10

  task_container_assign_public_ip = "true"
  task_container_image            = "${var.task_container_image}"
  task_container_port             = "${var.task_container_port}"

  health_check = {
    "port"     = "traffic-port"
    "protocol" = "HTTP"
    "path"     = "/"
    "interval" = 10
    "timeout"  = 5
  }
}
