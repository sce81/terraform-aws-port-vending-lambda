resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({ Name = "${var.function_name}-logs" })
  )
}

resource "aws_iam_role" "lambda_execution" {
  name               = "${var.function_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({ Name = "${var.function_name}-execution-role" })
  )
}

resource "aws_iam_role_policy" "lambda_logging" {
  name   = "${var.function_name}-logging"
  role   = aws_iam_role.lambda_execution.id
  policy = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_lambda_function" "ctask" {
  function_name = var.function_name
  description   = "Shared Port account-vending handler for future CTASK requests."
  role          = aws_iam_role.lambda_execution.arn
  handler       = "app.handler"
  runtime       = "python3.12"
  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 10

  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logging,
  ]

  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({ Name = var.function_name })
  )
}

resource "aws_lambda_function_url" "ctask" {
  function_name      = aws_lambda_function.ctask.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "function_url" {
  statement_id           = "AllowPublicFunctionUrl"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.ctask.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}
