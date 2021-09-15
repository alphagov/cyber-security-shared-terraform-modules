locals {
  codebuild_project_name = "${var.pipeline_name}-${var.stage_name}-${var.action_name}"
}

resource "aws_codebuild_project" "code_pipeline_get_actions_required" {
  name        = local.codebuild_project_name
  description = "Reads changed_files.json and actions_triggers.json to produce actions_required.json."

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
      name  = "CHANGED_FILES_JSON"
      value = var.changed_files_json
    }

    environment_variable {
      name  = "ACTION_TRIGGERS_JSON"
      value = var.action_triggers_json
    }

    environment_variable {
      name  = "CHANGED_FILES_ARTIFACT"
      value = var.changed_files_artifact
    }

    environment_variable {
      name  = "ACTION_TRIGGERS_ARTIFACT"
      value = var.action_triggers_artifact
    }

    environment_variable {
      name  = "OUTPUT_ARTIFACT_PATH"
      value = var.output_artifact_path
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/codebuild_get_actions_required.yml")
  }

  tags = merge(var.tags, { "Name" : local.codebuild_project_name })
}
