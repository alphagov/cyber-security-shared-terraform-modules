# Get Changed File List
## Overview
This module gets the most recently changed files for a given repository and 
checks them against a supplied list of files to decide whether or not the pipeline needs
to rebuild certain infrastructure. 

## How it works
This module calls the `bin/get_pr_changed_files_list.sh` found inside the cd base image, which
calls the Github API in order to return a list of files changed in the most recently merged PR. 
These files, along with a supplied list of files that you want to watch for changes, are then passed
into `bin/check_for_changed_files.py` which checks the two lists for overlaps. Whether or not an overlap 
is found is saved as a boolean inside an artifact file and passed to the next stage of the pipeline, which 
can use this decide whether or not to rebuild its infrastructure. 

## Example Usage
Import the module into your terraform as below:
```
module "codebuild-get-changed-file-list" {
  source                      = "github.com/alphagov/cyber-security-shared-terraform-modules//codebuild/codebuild_git_diff"
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
  context_file_list           = jsonencode("[\"Dockerfile\", "bin/"]")
}
```
## Argument reference

For a full list of all variables needed for this module, as well as a short description on each, 
see [variables.tf](variables.tf). More complicated variables are detailed below:

`context_file_list` - this is a string list of paths that you want to monitor for changes. These
can point to either directories or to files themselves, and must be relative from the root of the
git repo. This should be jsonencoded, with quotes escaped (see example above).

## Outputs
This module outputs a file as an artifact to be passed to the next CodeBuild task. This can be found at
CODEBUILD_SRC_DIR_git_diff_file/rebuild_task.json. The file contains a boolean, which if True should trigger 
a rebuild.