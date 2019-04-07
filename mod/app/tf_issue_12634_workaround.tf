// BUG WORKAROUND (plombardi, 2019-04-06)
//
// Read: https://github.com/hashicorp/terraform/issues/12634
//
// Despite being closed it is NOT FIXED. Hashicorp closed it and did not open in the AWS provider repository where
// it belongs.
//
// The ECS service and the load balancer target group both depend on this which ensures they are not created until the
// load balancer is created.
//

resource "null_resource" "load_balancer" {
  triggers {
    load_balancer_name = "${var.load_balancer_arn}"
  }
}
