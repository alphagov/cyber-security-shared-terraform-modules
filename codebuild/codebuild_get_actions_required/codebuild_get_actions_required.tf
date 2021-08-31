resource "aws_codebuild_project" "code_pipeline_get_actions_required" {
  name        = "${var.pipeline_name}-get-actions-required-${var.environment}"
  description = "Reads changed_files.json and actions_triggers.json to produce actions_required.json."

  service_role = data.aws_iam_role.execution_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  secondary_artifacts {
    type                = "S3"
    name                = "actions_required.json"
    artifact_identifier = "actions_required"
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

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.deployment_account_id
    }

    environment_variable {
      name  = "ROLE_NAME"
      value = var.deployment_role_name
    }

    environment_variable {
      name  = "ACTION_TRIGGERS"
      value = var.action_triggers
    }


  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/codebuild_get_actions_required.yml")
  }
}
