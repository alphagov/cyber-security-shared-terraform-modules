# Invoke ECS run-task
## Overview
Uses the AWS CLI to run an `ecs run-task` according to the task definition
passed in.

Optionally wait for the execution to complete. 

## How it works


## Example Usage
Import the module into your terraform as below:
```
module "codebuild-get-changed-file-list" {
  source                      = "github.com/alphagov/cyber-security-shared-terraform-modules//codebuild/codebuild_get_changed_file_list"
  codebuild_service_role_name = var.codebuild_service_role_name
  deployment_account_id       = data.aws_caller_identity.current.account_id
  deployment_role_name        = var.deployment_role_name
  codebuild_image             = "gdscyber/cyber-security-cd-base-image:latest"
  pipeline_name               = var.pipeline_name
  environment                 = var.environment
  github_pat                  = var.github_pat
  repo_name                   = var.repo_name
  output_filename             = var.output_filename
  docker_hub_credentials      = var.docker_hub_credentials
  output_artifact_path        = var.artifact_path
  artifact_bucket             = data.aws_s3_bucket.artifact_store.bucket
}
```
## Argument reference

For a full list of all variables needed for this module, as well as a short description on each,
see [variables.tf](variables.tf).

## Outputs
This module outputs a file as an artifact to be passed to the next CodeBuild task. This can be found at
CODEBUILD_SRC_DIR_changed_files/changed_files.json.