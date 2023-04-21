variable "s3_processor_lambda_role" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "s3_processor_sqs_arn" {
  type = string
}

variable "log_prefixes" {
  type = list(string)
}
