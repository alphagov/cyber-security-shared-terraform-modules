locals {
  codebuild_project_name = "${var.pipeline_name}-${var.stage_name}-${var.action_name}"
}

resource "aws_codebuild_project" "codebuild_invoke_ecs_run_task" {
  name        = local.codebuild_project_name
  description = "Run aws ecs run-task with arguments derived from terraform output"

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
      name  = "ROLE_NAME"
      value = var.deployment_role_name
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }

    environment_variable {
      name  = "TASK_COUNT"
      value = var.task_count
    }

    environment_variable {
      name  = "LAUNCH_TYPE"
      value = var.launch_type
    }

    environment_variable {
      name  = "TERRAFORM_OUTPUT_ARTIFACT"
      value = var.terraform_output_artifact
    }

    environment_variable {
      name  = "TERRAFORM_OUTPUT_FILE"
      value = var.terraform_output_file
    }

    environment_variable {
      name  = "ECS_CLUSTER_PROP"
      value = var.terraform_output_ecs_cluster
    }

    environment_variable {
      name  = "ECS_GROUP_PROP"
      value = var.terraform_output_ecs_group
    }

    environment_variable {
      name  = "TASK_DEFINITION_PROP"
      value = var.terraform_output_ecs_task_definition
    }

    environment_variable {
      name  = "NETWORK_CONFIG_PROP"
      value = var.terraform_output_ecs_network_config
    }

    environment_variable {
      name  = "AWAIT_COMPLETION"
      value = var.await_completion
    }

    environment_variable {
      name  = "AWAIT_EXIT_CODE"
      value = var.await_exit_code
    }

    environment_variable {
      name  = "AWAIT_LAST_STATUS"
      value = var.await_last_status
    }

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/codebuild_invoke_ecs_run_task.yml")
  }

  tags = merge(var.tags, { "Name" : local.codebuild_project_name })
}
