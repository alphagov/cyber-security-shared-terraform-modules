# Invoke ECS run-task
## Overview
Uses the AWS CLI to run an `ecs run-task` according to the task definition
passed in.

Optionally wait for the execution to complete.

## How it works


## Example Usage
Import the module into your terraform as below:
```
module "codebuild_build_import_config_staging" {
  source                                = "github.com/alphagov/cyber-security-shared-terraform-modules//codebuild/codebuild_invoke_ecs_run_task"
  deployment_account_id                 = var.aws_account_id_staging
  deployment_role_name                  = "CodePipelineDeployerRole_${var.aws_account_id_staging}"
  codebuild_service_role_name           = data.aws_iam_role.pipeline_role.name
  stage_name                            = "CodePipelineStage"
  action_name                           = "CodePipelineAction"
  pipeline_name                         = "pipeline-name"
  environment                           = var.environment
  region                                = data.aws_region.current.name
  terraform_output_artifact             = "terraform_output_staging"
  terraform_output_file                 = "terraform_output.json"
  terraform_output_ecs_cluster          = "ecs_cluster_output_variable_name"
  terraform_output_ecs_group            = "ecs_group_output_variable_name"
  terraform_output_ecs_task_definition  = "ecs_task_definition_output_variable_name"
  terraform_output_ecs_network_config   = "ecs_network_config_output_variable_name"
  task_count                            = 1
  launch_type                           = "FARGATE"
  await_completion                      = true
}

```
## Argument reference

For a full list of all variables needed for this module, as well as a short description on each,
see [variables.tf](variables.tf).

## Outputs

This module has a single output:
- `project_name` - The name of the created CodeBuild project. In the `configuration` block of the
  CodePipeline `action` you want to use this project in, set `ProjectName` to this value.