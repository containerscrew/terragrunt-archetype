resource "aws_iam_policy" "lambda_trigger_policy" {
  name_prefix = "lambda-trigger-iam-policy"
  description = "Permissions for lambda in some AWS resources"
  policy      = data.aws_iam_policy_document.lambda_trigger_iam_policy.json
  tags        = var.tags
}

data "aws_iam_policy_document" "lambda_trigger_iam_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}
