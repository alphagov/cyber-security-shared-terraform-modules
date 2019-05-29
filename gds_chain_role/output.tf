output "role_id" {
  value = "${aws_iam_role.gds_security_audit_role.id}"
}

output "role_arn" {
  value = "${aws_iam_role.gds_security_audit_role.arn}"
}

output "policy_id" {
  value = "${aws_iam_role_policy.gds_security_audit_role_policy.id}"
}
