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

variable "codebuild_image" {
  description = ""
  type        = string
}

variable "region" {
  description = "The AWS region to launch the ECS task in"
  type        = string
  default     = "eu-west-2"
}

variable "ecs_cluster" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_group" {
  description = "The name of the ECS group"
  type        = string
}

variable "task_definition" {
  description = "The arn of the current task definition"
  type        = string
}

variable "task_count" {
  description = "The number of instances of the task to launch"
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "Which ECS launch type to use"
  type        = string
  default     = "FARGATE"
}

variable "network_config" {
  description = "The JSON network settings to run the task in (subnets and security groups)"
  type        = string
  default     = ""
}

variable "await_completion" {
  description = "Optionally switch off polling for task completion"
  type        = boolean
  default     = true
}

variable "docker_hub_credentials" {
  description = "The name of the Secrets Manager secret that contains the username and password for the Docker Hub"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Pass through parent service tags to CodeBuild project resource"
  default     = {}
}
