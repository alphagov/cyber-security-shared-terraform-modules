resource "aws_codebuild_project" "code_pipeline_git_diff" {
  name        = "${var.pipeline_name}-git-diff-${var.environment}"
  description = "Get diff files for a given repository and store as artifact."

  service_role = data.aws_iam_role.execution_role.arn

  artifacts {
    location = var.artifact_bucket
    type = "S3"
    path = "${var.pipeline_name}-${var.environment}/"
    name = var.output_filename
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    registry_credential {
        credential          = data.aws_secretsmanager_secret.dockerhub_creds.arn
        credential_provider = "SECRETS_MANAGER"
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
      type  = "SECRETS_MANAGER"
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
