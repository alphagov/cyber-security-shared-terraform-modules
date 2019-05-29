output "role_id" {
  value = "${aws_iam_role.gds_chain_role.id}"
}

output "role_arn" {
  value = "${aws_iam_role.gds_chain_role.arn}"
}

output "policy_id" {
  value = "${aws_iam_role_policy.gds_chain_role_policy.id}"
}
