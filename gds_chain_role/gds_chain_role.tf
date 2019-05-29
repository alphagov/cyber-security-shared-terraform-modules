data "template_file" "trust" {
  template = "${file("${path.module}/json/trust.json")}"

  vars {
    trust_arn  = "${var.trust_arn}"
  }
}

resource "aws_iam_role" "gds_chain_role" {
  name = "${var.role_name}"

  assume_role_policy = "${data.template_file.trust.rendered}"
}


