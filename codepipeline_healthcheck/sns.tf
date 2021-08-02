data "aws_sns_topic" "health_notification" {
  name = var.health_notification_topic_name
}

resource "aws_sns_topic_policy" "default" {
  arn    = data.aws_sns_topic.health_notification.arn
  policy = data.aws_iam_policy_document.events_to_sns.json
}

data "aws_iam_policy_document" "events_to_sns" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [data.aws_sns_topic.health_notification.arn]
  }
}
