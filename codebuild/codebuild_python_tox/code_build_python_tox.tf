locals {
  codebuild_project_name = "${var.pipeline_name}-python-tox-${var.environment}"
}
resource "aws_codebuild_project" "code_pipeline_python_tox" {
  name        = local.codebuild_project_name
  description = "Run Python tox"

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
      name  = "PYTHON_SOURCE_DIRECTORY"
      value = var.python_source_directory
    }

    environment_variable {
      name  = "PYTHON_VERSION"
      value = var.python_version
    }

    environment_variable {
      name  = "ROLE_NAME"
      value = var.deployment_role_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_python_tox.yml")
  }

  tags = merge(var.tags, { "Name" : local.codebuild_project_name })
}
