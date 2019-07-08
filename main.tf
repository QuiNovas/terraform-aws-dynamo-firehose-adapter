resource "aws_iam_policy" "dynamo_firehose_adapter" {
  name   = "${var.name_prefix}DynamoFirehoseAdapter"
  policy = data.aws_iam_policy_document.dynamo_firehose_adapter.json
}

module "dynamo_firehose_adapter" {
  dead_letter_arn = var.dead_letter_arn
  environment_variables = {
    DELIVERY_STREAM_NAME = var.kinesis_firehose_name
    DYNAMNODB_IMAGE_TYPE = var.dynamodb_image_type
  }
  handler       = "function.handler"
  kms_key_arn   = var.kms_key_arn
  l3_object_key = "quinovas/dynamo-firehose-adapter/dynamo-firehose-adapter-0.0.1.zip"
  name          = "${var.name_prefix}dynamo-firehose-adapter"
  policy_arns = [
    aws_iam_policy.dynamo_firehose_adapter.arn,
  ]
  runtime           = "python2.7"
  source            = "QuiNovas/lambdalambdalambda/aws"
  timeout           = 60
  version           = "3.0.1"
}

resource "aws_lambda_event_source_mapping" "dynamo_firehose_adapter" {
  batch_size        = var.batch_size
  event_source_arn  = var.dynamodb_stream_arn
  enabled           = true
  function_name     = module.dynamo_firehose_adapter.arn
  starting_position = "TRIM_HORIZON"
}

