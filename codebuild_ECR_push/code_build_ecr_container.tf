resource "aws_codebuild_project" "code_pipeline_ecr_container" {
  name        = "code-pipeline-ecr-container"
  description = "Build container and push to ECR"

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

    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = var.dockerhub_username
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      value = var.dockerhub_password
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "ECR_CONTEXT"
      value = var.ecr_context
    }

    environment_variable {
      name  = "ECR_IMAGE_TAG"
      value = var.ecr_image_tag
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.deployment_account_id
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region_name
    }

    environment_variable {
      name  = "ROLE_NAME"
      value = var.deployment_role_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_ecr_container.yml")
  }
}
