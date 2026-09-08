variable "function_name" {
  type        = string
  description = "Name assigned to the Lambda function."
  default     = "port-account-vending-ctask"

  validation {
    condition     = length(var.function_name) <= 64 && can(regex("^[a-zA-Z0-9_-]+$", var.function_name))
    error_message = "function_name must be 64 characters or fewer and contain only letters, numbers, hyphens, and underscores."
  }
}

variable "env" {
  type        = string
  description = "Environment used in standard resource tags."
  default     = "shared"
}

variable "project" {
  type        = string
  description = "Project used in standard resource tags."
  default     = "port"
}

variable "name" {
  type        = string
  description = "Logical resource name used in standard resource tags."
  default     = "account-vending-ctask"
}

variable "extra_tags" {
  type        = map(any)
  description = "Additional tags to apply to taggable AWS resources."
  default     = {}
}
