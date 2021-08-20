resource "aws_codebuild_project" "code_pipeline_terraform_apply" {

  for_each = var.aws_accounts

  name        = "${var.pipeline_name}-terraform-${each.value.environment}"
  description = "Run Terraform apply"

  service_role = data.aws_iam_role.execution_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    privileged_mode             = false

    registry_credential {
      credential_provider = "SECRETS_MANAGER"
      credential          = data.aws_secretsmanager_secret.dockerhub_creds.arn
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = each.value.aws_account_id
    }

    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = "0.12.31"
    }

    environment_variable {
      name  = "ROLE_NAME"
      value = "${var.deployment_role_name}_${each.value.aws_account_id}"
    }

    environment_variable {
      name  = "STS_ASSUME_ROLE_DURATION"
      value = var.sts_assume_role_duration
    }


    environment_variable {
      name  = "BACKEND_VAR_FILE"
      value = var.backend_var_file
    }

    environment_variable {
      name  = "APPLY_VAR_FILE"
      value = var.apply_var_file
    }

    environment_variable {
      name  = "TERRAFORM_DIRECTORY"
      value = var.terraform_directory
    }

    environment_variable {
      name  = "POST_TERRAFORM_APPLY_COMMAND"
      value = var.post_terraform_apply_command
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_terraform_apply.yml")
  }
}
