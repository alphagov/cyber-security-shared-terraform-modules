resource "aws_codebuild_project" "code_pipeline_get_changed_files" {

  name        = "code-pipeline-get-changed-files"
  description = "Get changed files into artifact store"

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
      name  = "REPO_NAME"
      value = var.repo_name
    }

    environment_variable {
      name  = "TERRAFORM_DIRECTORY"
      value = var.terraform_directory
    }

    environment_variable {
      name  = "GITHUB_PAT"
      value = data.aws_ssm_parameter.github_pat.value
    }

    environment_variable {
      name  = "GITHUB_ORG"
      value = "alphagov"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/codebuild_get_changed_files.yml")
  }

}
