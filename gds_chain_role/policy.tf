data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [var.assume_arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "gds_chain_role_policy" {
  name   = "${var.role_name}Policy"
  role   = aws_iam_role.gds_chain_role.id
  policy = data.aws_iam_policy_document.policy.json
}

