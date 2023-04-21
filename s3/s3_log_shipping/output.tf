output "s3_policy" {
  value = data.aws_iam_policy_document.s3.json
}
