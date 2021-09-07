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

variable "output_artifact_path" {
  description = "the S3 path to store the output atrifact"
  type        = string
}

variable "codebuild_image" {
  description = "the image in which you want to run the codebuild task"
  type        = string
}

variable "action_triggers" {
  description = "the path to the action_triggers.json file in your repo, relative to the root of the repo."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Pass through parent service tags to CodeBuild project resource"
  default     = {}
}
