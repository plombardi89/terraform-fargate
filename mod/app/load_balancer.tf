resource "aws_security_group" "this" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.application}"
  description = "${var.application} service security group"
  tags        = "${merge(var.tags, map("Name", "${var.application}"))}"
}

resource "aws_security_group_rule" "egress" {
  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "ingress" {
  security_group_id        = "${aws_security_group.this.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.task_container_port}"
  to_port                  = "${var.task_container_port}"
  source_security_group_id = "${var.load_balancer_security_group_id}"
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = "${var.load_balancer_arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.this.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "this" {
  depends_on           = ["null_resource.load_balancer"]
  vpc_id               = "${var.vpc_id}"
  protocol             = "${var.task_container_protocol}"
  port                 = "${var.task_container_port}"
  target_type          = "ip"
  health_check         = ["${var.health_check}"]
  deregistration_delay = "${var.load_balancer_deregistration_delay}"

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(var.tags, map("Name", "${var.application}-target-${var.task_container_port}"))}"
}
