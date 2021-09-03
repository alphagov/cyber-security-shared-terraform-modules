variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline we're creating a health notification event for"
}

variable "health_notification_topic_name" {
  type        = string
  description = "Name of the SNS topic used for the health notification"
}
