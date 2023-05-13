module "lambda_trigger_function" {
  create          = var.lambda_trigger_function.create
  create_function = var.lambda_trigger_function.create_function

  source  = "terraform-aws-modules/lambda/aws"
  version = "4.0.1"

  function_name          = var.lambda_trigger_function.name
  description            = var.lambda_trigger_function.description
  handler                = var.lambda_trigger_function.handler
  runtime                = var.lambda_trigger_function.runtime
  timeout                = var.lambda_trigger_function.timeout
  memory_size            = var.lambda_trigger_function.memory_size
  ephemeral_storage_size = var.lambda_trigger_function.ephemeral_storage_size
  create_package         = var.lambda_trigger_function.create_package
  environment_variables  = {}
  local_existing_package = data.archive_file.code_zip.output_path
  publish                = true

  // Events
  maximum_retry_attempts       = var.lambda_trigger_function.maximum_retry_attempts
  maximum_event_age_in_seconds = var.lambda_trigger_function.maximum_retry_attempts

  // Cloudwatch logging
  cloudwatch_logs_tags              = var.tags
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 7

  allowed_triggers = {
    CloudWatch = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.lambda_cloudwatch_event_rule.arn
    }
  }

  // IAM policies
  attach_policy = var.lambda_trigger_function.attach_policy
  policy        = aws_iam_policy.lambda_trigger_policy.arn

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "lambda_cloudwatch_event_rule" {
  name                = "${var.lambda_trigger_function.name}-event-rule"
  description         = "${var.lambda_trigger_function.name} event rule"
  schedule_expression = var.lambda_trigger_function.event_rule_schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda_cloudwatch_event_target" {
  rule = aws_cloudwatch_event_rule.lambda_cloudwatch_event_rule.name
  arn  = module.lambda_trigger_function.lambda_function_arn
}
