resource "aws_codebuild_project" "code_pipeline_container_build_docker_hub" {
  name        = "${var.pipeline_name}-dockerhub-deploy-${var.environment}"
  description = "Build and push images to dockerhub"

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
    privileged_mode             = false

    environment_variable {
      name  = "IMAGE_NAME"
      value = var.image_name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = var.image_tag
    }

    environment_variable {
      name  = "BUILD_CONTEXT"
      value = var.build_context
    }

    environment_variable {
      name  = "DOCKERFILE"
      value = var.dockerfile
    }

    environment_variable {
      name  = "DOCKER_HUB_USERNAME"
      value = var.docker_hub_username
    }

    environment_variable {
      name  = "DOCKER_HUB_PASSWORD"
      value = var.docker_hub_password
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build.yml")
  }
}

data "aws_iam_role" "execution_role" {
  name = var.service_role_name
}
