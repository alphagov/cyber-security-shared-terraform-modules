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

variable "lambda_arn" {
  type        = string
  description = "ARN for the Lambda function invoked on a schedule"
}
