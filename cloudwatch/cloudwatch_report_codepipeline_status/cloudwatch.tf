resource "aws_cloudwatch_event_rule" "codepipeline_event_rule" {
  name        = "codepipeline-events-${substr(var.pipeline_name, 0, 44)}"
  description = "Codepipeline Execution State Change"

  event_pattern = <<EOF
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Pipeline Execution State Change"
  ],
  "detail": {
    "pipeline": [
      "${var.pipeline_name}"
    ],
    "state": [
      "SUCCEEDED",
      "FAILED",
      "STARTED",
      "ABANDONED"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.codepipeline_event_rule.name
  target_id = "SendToSNS"
  arn       = data.aws_sns_topic.health_notification.arn
}
