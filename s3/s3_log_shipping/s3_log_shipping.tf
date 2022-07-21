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
# https://docs.amazonaws.cn/en_us/AmazonS3/latest/userguide/about-object-ownership.html
resource "aws_s3_bucket_ownership_controls" "transfer_object_ownership" {
  bucket = var.s3_name

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
