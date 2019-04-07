resource "aws_vpc" "this" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = "${merge(var.tags, map("Name", var.name))}"
}

resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"
  tags   = "${merge(var.tags, map("Name", var.name))}"
}

resource "aws_route" "internet" {
  route_table_id         = "${aws_vpc.this.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"
}

resource "aws_subnet" "public" {
  count             = "${length(var.availability_zones)}"
  availability_zone = "${element(sort(var.availability_zones), count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, 4, count.index)}"
  vpc_id            = "${aws_vpc.this.id}"
  tags              = "${merge(var.tags, map("Name", "${var.name}-${format("public-%03d", count.index)}"))}"

  //
  //  tags {
  //    Name = "${var.name}-${format("public-%03d", count.index)}"
  //  }
}
