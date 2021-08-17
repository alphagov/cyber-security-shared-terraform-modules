resource "aws_codebuild_project" "code_pipeline_git_diff" {
  name        = "${var.pipeline_name}-git-diff-${var.environment}"
  description = "Get diff files for a given repository and store as artifact."

  service_role = data.aws_iam_role.execution_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  secondary_artifacts {
    type                = "CODEPIPELINE"
    name                = var.output_filename
    artifact_identifier = "git-diff-file"
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

     environment_variable {
      name  = "OUTPUT_FILENAME"
      value = var.output_filename
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_git_diff.yml")
  }
}
