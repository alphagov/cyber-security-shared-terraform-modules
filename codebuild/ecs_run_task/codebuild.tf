resource "aws_codebuild_project" "ecs_run_task" {
  name        = "${var.pipeline_name}-ecs-run-task-${var.environment}"
  description = "Run an ECS task"

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
      name  = "REGION"
      value = var.region_name
    }

    environment_variable {
      name  = "TASK_NAME"
      value = var.ecs_task_name
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
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
      name  = "REPO_NAME"
      value = var.repo_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_terraform.yml")
  }
}
