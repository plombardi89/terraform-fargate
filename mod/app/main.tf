data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.application}"
  retention_in_days = "${var.log_retention_in_days}"
  tags              = "${var.tags}"
}

data "null_data_source" "task_environment" {
  count = "${length(var.task_container_environment)}"

  inputs = {
    name  = "${element(keys(var.task_container_environment), count.index)}"
    value = "${element(values(var.task_container_environment), count.index)}"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.application}"
  execution_role_arn       = "${aws_iam_role.execution_role.arn}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.task_definition_cpu}"
  memory                   = "${var.task_definition_memory}"
  task_role_arn            = "${aws_iam_role.task_role.arn}"

  container_definitions = <<EOF
[{
    "name": "${var.application}",
    "image": "${var.task_container_image}",
    "essential": true,
    "portMappings": [
        {
            "containerPort": ${var.task_container_port},
            "hostPort": ${var.task_container_port},
            "protocol":"${var.task_container_protocol}"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
            "awslogs-region": "${data.aws_region.current.name}",
            "awslogs-stream-prefix": "container"
        }
    },
    "command": ${jsonencode(var.task_container_command)},
    "environment": ${jsonencode(data.null_data_source.task_environment.*.outputs)}
}]
EOF
}

resource "aws_ecs_service" "this" {
  depends_on                         = ["null_resource.load_balancer"]
  name                               = "${var.application}"
  cluster                            = "${var.cluster_id}"
  task_definition                    = "${aws_ecs_task_definition.this.arn}"
  desired_count                      = "${var.replicas}"
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
  health_check_grace_period_seconds  = "${var.health_check_grace_period_seconds}"

  network_configuration {
    subnets          = ["${var.public_subnet_ids}"]
    security_groups  = ["${aws_security_group.this.id}"]
    assign_public_ip = "${var.task_container_assign_public_ip}"
  }

  load_balancer {
    container_name   = "${var.application}"
    container_port   = "${var.task_container_port}"
    target_group_arn = "${aws_lb_target_group.this.arn}"
  }
}
