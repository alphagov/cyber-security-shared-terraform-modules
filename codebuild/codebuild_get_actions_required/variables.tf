variable "environment" {
  type        = string
  description = "Enviroment this module will be ran"
}

variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline"
}

variable "stage_name" {
  description = "The name of the pipeline stage"
  type        = string
  default     = "default"
}

variable "action_name" {
  description = "The name of the pipeline stage action"
  type        = string
  default     = "default"
}

variable "deployment_account_id" {
  description = "The AWS account id where you are deploying to ECR image to."
  type        = string
}

variable "deployment_role_name" {
  description = "The name of the role used to deploy the ECR image."
  type        = string
}

variable "codebuild_service_role_name" {
  description = "The role code build uses to access other AWS services."
  type        = string
}

variable "artifact_bucket" {
  description = "S3 path where the artifact will be stored."
  type        = string
}

variable "codebuild_image" {
  description = "the image in which you want to run the codebuild task"
  type        = string
}


variable "changed_files_artifact" {
  description = "the input artifact containing the changed files json file."
  type        = string
  default     = "changed_files"
}

variable "changed_files_json" {
  description = "the path to the changed_files.json file in your repo (can include artifact var)."
  type        = string
  default     = "$CODEBUILD_SRC_DIR_changed_files/changed_files.json"
}

variable "action_triggers_json" {
  description = "the path to the action_triggers.json file in your repo, relative to the root of the repo."
  type        = string
  default     = "$CODEBUILD_SRC_DIR/terraform/deployments/670214072732/action_triggers.json"
}

variable "output_artifact_path" {
  description = "The file name to be created"
  type        = string
  default     = "actions_required.json"
}

variable "tags" {
  type        = map(string)
  description = "Pass through parent service tags to CodeBuild project resource"
  default     = {}
}
