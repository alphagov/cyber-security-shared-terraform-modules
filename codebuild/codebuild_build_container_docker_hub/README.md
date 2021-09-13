# CodeBuild Container Build and Push to Docker Hub module

This module creates a CodeBuild project.

## Example Usage
```terraform
module "codebuild-dockerhub-build" {
  source              = "github.com/alphagov/cyber-security-shared-terraform-modules//codebuild/codebuild_project_container_build_docker_hub"
  service_role_name   = "example-codebuild-service-role"
  docker_hub_repo     = "username/image_name"
  build_context       = "."
  dockerfile          = "Dockerfile"
  docker_hub_username = "example-username"
  docker_hub_password = "example-password"
  pipeline_name       = "example-pipeline"
  environment         = "test"
}

resource "aws_codepipeline" "example-pipeline" {
  name = "example-pipeline"
  ...

  stage {
    name = "Source"
    
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["git_repo"]
      configuration = {
        ...
      }
    }
  }

  stage {
    name = "DockerBuildAndPush"

    action {
      name             = "DockerBuildAndPush"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["git_repo"]
      output_artifacts = []

      configuration = {
        ProjectName = module.codebuild-dockerhub-build.project_name
      }
    }
  }
}
```

## Argument Reference
The following arguments are required:
- `service_role_name` - The name of the CodeBuild service role to use for this project.
- `docker_hub_repo` - The repository on Docker Hub, in the format `username/image_name`.
- `build_context` - The path to the folder you want to use as context for building the image,
  relative to the root of the repo passed into the CodeBuild project.
- `dockerfile` - The path to the Dockerfile that defines the image, relative to the root of the repo
  passed into the CodeBuild project.
- `docker_hub_username` - The username used to authenticate with Docker Hub.
- `docker_hub_password` - The password used to authenticate with Docker Hub.
- `pipeline_name` - The name of the pipeline this project will be a part of. (Technically this can
  be anything, but it helps with associating the CodeBuild projects with their respective pipelines)
- `environment` - The environment, such as "staging" or "production".

The following arguments are optional:
- `image_tag` - The tag to apply to the image. `latest` by default.

## Attributes Reference
This module has a single output:
- `project_name` - The name of the created CodeBuild project. In the `configuration` block of the
  CodePipeline `action` you want to use this project in, set `ProjectName` to this value.
