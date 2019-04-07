data "aws_iam_policy_document" "task_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_permissions" {
  statement {
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.this.arn}"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

data "aws_iam_policy_document" "task_execution_permissions" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "${var.application}-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.task_assume.json}"
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.application}"
  role   = "${aws_iam_role.execution_role.id}"
  policy = "${data.aws_iam_policy_document.task_execution_permissions.json}"
}

resource "aws_iam_role" "task_role" {
  name               = "${var.application}-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.task_assume.json}"
}

resource "aws_iam_role_policy" "logging" {
  name   = "${var.application}-logging"
  role   = "${aws_iam_role.task_role.id}"
  policy = "${data.aws_iam_policy_document.task_permissions.json}"
}
