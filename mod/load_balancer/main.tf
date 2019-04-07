locals {
  name_prefix = "${var.name_prefix}-${var.type == "network" ? "nlb" : "alb"}"
}

data "aws_region" "current" {}

resource "aws_lb" "this" {
  name               = "${local.name_prefix}"
  load_balancer_type = "${var.type}"
  internal           = false
  subnets            = ["${var.subnet_ids}"]
  security_groups    = ["${aws_security_group.this.*.id}"]
  idle_timeout       = "${var.idle_timeout}"

  access_logs = {
    prefix  = "${var.access_logs_prefix}"
    bucket  = "${var.access_logs_bucket}"
    enabled = "true"
  }

  tags = "${merge(var.tags, map("Name", "${local.name_prefix}"))}"
}

resource "aws_security_group" "this" {
  count  = "${var.type == "network" ? 0 : 1}"
  name   = "${local.name_prefix}-sg"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${local.name_prefix}-sg"))}"
}

resource "aws_security_group_rule" "egress" {
  count             = "${var.type == "network" ? 0 : 1}"
  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
