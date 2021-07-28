data "aws_sns_topic" "health_notification" {
  name = var.health_notification_topic_name
}
