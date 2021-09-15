# Get Actions Required
## Overview
compares a committed action_triggers.json file with the changed_files.json artifact (produced in `codebuild/codebuild_get_changed_file_list`) to determine whether an action should be triggered based on the files that have changed. 
This produces `actions_required.json` which contains a true/false value for each action in the pipeline, which is stored
as an output artifact.

This allows us to make the pipelines run more quickly and use less resource by only triggering actions required based on the code that has changed. 

## How it works
This module calls the `bin/get_actions_required.py` script found inside the cd base image, which 
compares a list of most recently changed files (supplied by the module `codebuild_get_changed_files`), and
a list of action triggers (saved as `action_triggers.json` along side your CodePipeline terraform).


## Example Usage
Import the module into your terraform as below:
```
module "codebuild-get-actions-required" {
  source                      = "github.com/alphagov/cyber-security-shared-terraform-modules//codebuild/codebuild_get_actions_required"
  codebuild_service_role_name = var.codebuild_service_role_name
  deployment_account_id       = data.aws_caller_identity.current.account_id
  deployment_role_name        = "CodePipelineDeployerRole_${data.aws_caller_identity.current.account_id}"
  codebuild_image             = "gdscyber/cyber-security-cd-base-image:latest"
  pipeline_name               = var.pipeline_name
  environment                 = var.environment
  output_artifact_path        = var.output_artifact_path
  artifact_bucket             = data.aws_s3_bucket.artifact_store.bucket
  action_triggers_json        = var.action_triggers
  docker_hub_credentials      = var.docker_hub_credentials
}
```

Create a file called `action_triggers.json` and the location of `var.action_triggers` in the following format:

```
[
  {
     "action": "build-keycloak-runtime-container", 
     "trigger_paths": [
        "Dockerfile",
        "runtime/context"
      ]
    },
    {
       "action": "build-keycloak-config-container", 
       "trigger_paths": [
         "keycloak-config/Dockerfile", 
         "keycloak-config/context"
       ]
   }
]
```

In your `codepipeline.tf`, pass in `CHECK_TRIGGER` and `ACTION_NAME` flags as env vars to corresponding Codebuild
modules, along with `actions_required` as an `input_atrifact`:

```
stage {
    name = "build-containers"

    action {
      name             = "build-keycloak-config-container"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["git_authenticate", "actions_required"]
      configuration = {
        ProjectName          = aws_codebuild_project.build_keycloak_config_container
        PrimarySource        = "git_authenticate"
        EnvironmentVariables = jsonencode([{"name": "CHECK_TRIGGER": "value": 1, "name":"ACTION_NAME, "value": "build-keycloak-config-container"}])
      }
   }

    action {
      name             = "build-keycloak-runtime-container"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["git_authenticate", "actions_required"]
      configuration = {
        ProjectName          = aws_codebuild_project.build_keycloak_runtime_container
        PrimarySource        = "git_authenticate"
        EnvironmentVariables = jsonencode([{"name": "CHECK_TRIGGER": "value": 1, "name":"ACTION_NAME, "value": "build-keycloak-runtime-container"}])
      }
   }
}

```

Each module that uses `actions_required` then needs to o implement a pre_build phase which queries the actions_required.json for the given ACTION_NAME if defined to create a TRIGGER_BUILD env var and then conditionally executes the actions defined in the other phases based on the value of TRIGGER_BUILD:

```
phases:
  pre_build:
    commands:
      - ACTIONS_REQUIRED="${CODEBUILD_SRC_DIR_actions_required}/actions_required.json"
      - if [ -n "$CHECK_TRIGGER" ]; then
          TRIGGER_BUILD=$(jq --arg ACTION_NAME "$ACTION_NAME" '.[] | select(.action ==$ACTION_NAME).required' $ACTIONS_REQUIRED); 
        else 
          echo "CHECK_TRIGGER not supplied, defaulting to true..";
          TRIGGER_BUILD=true; 
        fi
```
## Argument reference

For a full list of all variables needed for this module, as well as a short description on each, 
see [variables.tf](variables.tf). 

## Outputs
This module outputs a file as an artifact to be passed to the next CodeBuild task. This can be found at
`$CODEBUILD_SRC_DIR_actions_required/actions_required.json`. The file contains a list of CodeBuild steps, 
and whether or not they need to be rebuilt, for example:

```
[
    {"action": "build-keycloak-runtime-container", "required": true},
    {"action": "build-keycloak-config-container", "required": false}
]
```
