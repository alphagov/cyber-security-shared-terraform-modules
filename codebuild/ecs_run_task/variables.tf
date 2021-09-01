variable "region_name" {
  type    = string
  default = "eu-west-2"
}

variable environment {
  description = "e.g. staging, production"
  type        = string
}

variable deployment_account_id {
  description = "the account into which the terraform will be deployed"
  type        = string
}

variable deployment_role_name {
  description = "the role used to deploy the terraform"
  type        = string
}

variable "ecs_task_name" {
  description = "Name of the ECS task to run"
  type        = string
}

variable "pipeline_name" {
  description = "The name of the pipeline this project will be a part of"
  type        = string
}

variable "repo_name" {
  description = "Name of the repo? idk lol"
  type = string
}
