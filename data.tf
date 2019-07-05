data "aws_iam_policy_document" "dynamo_firehose_adapter" {
  statement {
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams",
    ]
    resources = [
      var.dynamodb_stream_arn,
    ]
    sid = "AllowReadingFromDynamoDBStream"
  }

  statement {
    actions = [
      "firehose:PutRecordBatch",
    ]
    resources = [
      var.kinesis_firehose_arn,
    ]
    sid = "AllowWritingToFirehose"
  }
}

