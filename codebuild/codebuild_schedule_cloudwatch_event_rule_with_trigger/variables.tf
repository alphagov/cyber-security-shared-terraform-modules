variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline we're creating a health notification event for"
}

# https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
variable "event_rule_schedule" {
  type        = string
  description = "Cron schedule for when the Cloudwatch Event Rule should run"
}

# TBD
#variable "event_patterns" {}

variable "lambda_name" {
  type        = string
  description = "Name of the Lambda function to invoke on a schedule"
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
  description = "the image in which you want to run the codebuild task"
  type        = string
}

variable "lambda_arn" {
  type        = string
  description = "ARN for the Lambda function invoked on a schedule"
}

variable "environment" {
  type        = string
  description = "Enviroment this module will be ran"
}
