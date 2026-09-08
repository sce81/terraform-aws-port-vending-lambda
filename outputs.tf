output "function_name" {
  value       = aws_lambda_function.ctask.function_name
  description = "Name of the deployed Lambda function."
}

output "function_arn" {
  value       = aws_lambda_function.ctask.arn
  description = "ARN of the deployed Lambda function."
}

output "invoke_arn" {
  value       = aws_lambda_function.ctask.invoke_arn
  description = "Invoke ARN for integrations that invoke the Lambda function."
}

output "function_url" {
  value       = aws_lambda_function_url.ctask.function_url
  description = "Public HTTPS URL for the account-vending CTASK handler."
}

output "execution_role_arn" {
  value       = aws_iam_role.lambda_execution.arn
  description = "ARN of the Lambda execution role."
}
