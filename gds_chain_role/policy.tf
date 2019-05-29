data "aws_caller_identity" "current" {}

data "template_file" "policy" {
  template = "${file("${path.module}/json/policy.json")}"

  vars {
    assume_arn = "${var.assume_arn}"
  }
}

resource "aws_iam_role_policy" "gds_chain_role_policy" {
  name    = "${var.role_name}Policy"
  role    = "${aws_iam_role.gds_chain_role.id}"
  policy  = "${data.template_file.policy.rendered}"
}
