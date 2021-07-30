resource "aws_codebuild_project" "code_pipeline_terraform" {
  name        = "code-pipeline-terraform"
  description = "Run terraform vdd alidate and then terraform apply"

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
    image                       = "gdscyber/cyber-security-concourse-base-image:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    privileged_mode             = false

    registry_credential {
      credential          = data.aws_secretsmanager_secret.dockerhub_creds.arn
      credential_provider = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }

    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = "0.12.31"
    }

    environment_variable {
      name  = "ROLE_NAME"
      value = var.role_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_terraform.yml")
  }
}
