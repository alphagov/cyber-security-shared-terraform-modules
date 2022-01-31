data "aws_iam_role" "execution_role" {
  name = var.codebuild_service_role_name
}

data "aws_ssm_parameter" "deploy_key" {
  name = var.deploy_key
}

data "aws_secretsmanager_secret" "dockerhub_creds" {
  name = var.docker_hub_credentials
}
