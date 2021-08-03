resource "aws_codebuild_project" "code_pipeline_container_build_docker_hub" {
  name        = "codebuild-project-container-build-docker-hub"
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
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
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
      name  = "DOCKER_HUB_CREDS"
      value = var.docker_hub_creds
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/code_build.yml")
  }
}