locals {
  codebuild_project_name = "${var.pipeline_name}-${var.stage_name}-${var.action_name}"
}

resource "aws_codebuild_project" "codebuild_get_changed_file_list" {
  name        = local.codebuild_project_name
  description = "Get diff files for a given repository and store as artifact."

  service_role = data.aws_iam_role.execution_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  secondary_artifacts {
    type                = "S3"
    name                = "changed_files.json"
    artifact_identifier = "changed_files"
    location            = var.artifact_bucket
    path                = var.output_artifact_path
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
      name  = "ROLE_NAME"
      value = var.deployment_role_name
    }

    environment_variable {
      name  = "GITHUB_PAT"
      value = var.github_pat
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "GITHUB_ORG"
      value = var.github_org
    }

    environment_variable {
      name  = "REPO_NAME"
      value = var.repo_name
    }

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/codebuild_get_changed_file_list.yml")
  }

  tags = merge(var.tags, { "Name" : local.codebuild_project_name })
}
