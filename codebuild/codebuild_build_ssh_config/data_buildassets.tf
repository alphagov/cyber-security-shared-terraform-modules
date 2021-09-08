data "aws_iam_role" "execution_role" {
  name = var.codebuild_service_role_name
}

data "aws_ssm_parameter" "deploy_key" {
  name = var.deploy_key
}