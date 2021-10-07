# CodeBuild Terraform Apply module

This module creates a CodeBuild project.

The CodeBuild project deploys Terraform resources from a given directory in its environment, using a
given AWS role to grant the necessary permissions to make the changes.

In the `post_build` step, the CodeBuild project writes the output of the command `terraform output
-json` to a file, which is marked as an artifact that can be uploaded.

It is designed to be used within a CodePipeline pipeline.


## Example Usage
```terraform
module "codebuild-terraform-apply" {
  source                      = "github.com/alphagov/cyber-security-shared-terraform-modules//codebuild/codebuild_apply_terraform"
  codebuild_service_role_name = "example-codebuild-service-role"
  deployment_account_id       = 123456789012
  deployment_role_name        = "example-deployment-role"
  terraform_directory         = "terraform/deployments/123456789012"
  codebuild_image             = "repository/image_name"
  pipeline_name               = "example-pipeline"
  environment                 = "test"
  docker_hub_credentials      = "example-secret-name"
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
    name = "TerraformApply"

    action {
      name             = "TerraformApply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["git_repo"]
      output_artifacts = ["terraform_output"]

      configuration = {
        ProjectName = module.codebuild-terraform-apply.project_name
      }
    }
  }
}
```

## Argument Reference
The following arguments are required:
- `codebuild_service_role_name` - The name of the CodeBuild service role to use for this project.
- `deployment_account_id` - The ID number of the AWS account that the resources defined in the
  Terraform will be deployed to.
- `deployment_role_name` - The name of the IAM Role that will be assumed into to grant the
  permissions required to make changes in the deployment account. **The service role referred to by
  `codebuild_service_role_name` must be able to assume this role.**
- `terraform_directory` - The path to the directory that has the Terraform you want to deploy,
  relative to the root of the repo passed into the CodeBuild project.
- `codebuild_image` - The name of the DockerHub image to use for the CodeBuild project, in the form
  `username/image_name`.
- `pipeline_name` - The name of the pipeline this project will be a part of. (Technically this can
  be anything, but it helps with associating the CodeBuild projects with their respective pipelines)
- `environment` - The environment, such as "staging" or "production".
- `docker_hub_credentials` - The name of the Secrets Manager secret that contains the Docker Hub
  username and password, used to pull the image defined in `codebuild_image`.

The following arguments are optional:
- `backend_var_file` - If you use a var file during `terraform init`, set this to the path of that
  file
- `apply_var_file` - If you use a var file during `terraform apply`, set this to the path of that
  file
- `service_name` - This is used to modify the name of the JSON file that contains the output of
  `terraform output -json`. You may want to change this from the default if:
  - You need to reference the `terraform output` artifact, and
  - You use this module for multiple different Terraform deployments in the same target account.
  
  Defaults to `"terraform_output"`

## Attributes Reference
This module has a single output:
- `project_name` - The name of the created CodeBuild project. In the `configuration` block of the
  CodePipeline `action` you want to use this project in, set `ProjectName` to this value.
