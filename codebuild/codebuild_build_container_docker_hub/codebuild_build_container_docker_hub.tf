locals {
  codebuild_project_name = "${var.pipeline_name}-${var.stage_name}-${var.action_name}"
}

resource "aws_codebuild_project" "codebuild_build_container_docker_hub" {
  name        = local.codebuild_project_name
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
    privileged_mode             = true

    environment_variable {
      name  = "DOCKERHUB_IMAGE_TAG"
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
      name  = "DOCKERHUB_USERNAME"
      value = var.docker_hub_username
    }

    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      value = var.docker_hub_password
    }

    environment_variable {
      name  = "DOCKERHUB_REPO"
      value = var.docker_hub_repo
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/codebuild_build_container_docker_hub.yml")
  }

  tags = merge(var.tags, { "Name" : local.codebuild_project_name })
}

data "aws_iam_role" "execution_role" {
  name = var.service_role_name
}
