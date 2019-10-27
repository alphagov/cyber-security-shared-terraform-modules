output "maximum_message_size_arn" {
	description = "ARN for SentMessageSize Cloudwatch alarm"
	value = "aws_cloudwatch_metric_alarm.cloudwatch_metric_alarm.arn"
}
