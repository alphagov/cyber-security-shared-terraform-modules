data "aws_iam_policy_document" "sqs" {
  statement {
    sid = "SQSLogshipping"

    principals {
      type        = "AWS"
      identifiers = [var.s3_processor_lambda_role]
    }

    effect = "Allow"

    actions = [
      "SQS:ChangeMessageVisibility",
      "SQS:DeleteMessage",
      "SQS:ReceiveMessage",
      "SQS:GetQueueAttributes"
    ]

    resources = [
      var.sqs_arn
    ]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = "S3LogShipping"

    principals {
      type        = "AWS"
      identifiers = [var.s3_processor_lambda_role]
    }

    effect = "Allow"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_name}",
      "arn:aws:s3:::${var.s3_name}/*",
    ]
  }
}

# This is really important or thirdparty / cross account access to
# bucket objects won't be allowed.
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
resource "aws_s3_bucket_ownership_controls" "transfer_object_ownership" {
  bucket = var.s3_name

  rule {
    object_ownership = "BucketOwnerEnforced"
    # "BucketOwnerPreferred" if you're still using ACLs, but that will be impossible soon
  }
}

// Example usage repeat for s3 and SQS
# data "aws_iam_policy_document" "s3_combined" {
#   source_policy_documents = [
#     data.aws_iam_policy_document.s3_processor_logs_bucket_policy.json,
#     module.s3_log_shipping.s3_policy
#   ]
# }

# resource "aws_s3_bucket_policy" "s3_processor_logs_bucket_policy" {
#   bucket = aws_s3_bucket.input.id
#   policy = data.aws_iam_policy_document.s3_combined.json
# }
