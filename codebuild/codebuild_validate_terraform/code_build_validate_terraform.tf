locals {
  codebuild_project_name = "${var.pipeline_name}-${var.stage_name}-${var.action_name}"
}

resource "aws_codebuild_project" "code_pipeline_validate_terraform" {
  name        = local.codebuild_project_name
  description = "Run Terraform init and validate"

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
      value = var.deployment_account_id
    }

    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = "0.12.31"
    }

    environment_variable {
      name  = "ROLE_NAME"
      value = var.deployment_role_name
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
      name  = "TERRAFORM_DIRECTORY"
      value = var.terraform_directory
    }

    environment_variable {
      name  = "COPY_ARTIFACTS"
      value = jsonencode(var.copy_artifacts)
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_validate_terraform.yml")
  }

  tags = merge(var.tags, { "Name" : local.codebuild_project_name })
}
