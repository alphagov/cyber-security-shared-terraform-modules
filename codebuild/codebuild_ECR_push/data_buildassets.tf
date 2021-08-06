data "aws_iam_role" "execution_role" {
  name = var.codebuild_service_role_name
}
