data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trust_arns
    }
  }
}

resource "aws_iam_role" "gds_chain_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

