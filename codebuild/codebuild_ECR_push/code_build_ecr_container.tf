resource "aws_codebuild_project" "code_pipeline_ecr_container" {

  for_each = var.aws_accounts

  name        = "${var.pipeline_name}-ecr-${each.value.environment}"
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
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = var.docker_hub_username
    }

    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      value = var.docker_hub_password
    }

    environment_variable {
      name  = "ECR_CONTEXT"
      value = var.build_context
    }

    environment_variable {
      name  = "ECR_DOCKERFILE"
      value = var.dockerfile
    }

    environment_variable {
      name  = "ECR_IMAGE_REPO_NAME"
      value = "${var.ecr_image_repo_name}-${each.value.environment}"
    }

    environment_variable {
      name  = "ECR_IMAGE_TAG"
      value = var.image_tag
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = each.value.aws_account_id
    }

    environment_variable {
      name  = "ROLE_NAME"
      value = "${var.deployment_role_name}_${each.value.aws_account_id}"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build_ecr_container.yml")
  }
}
