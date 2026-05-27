variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  validation {
    condition     = length(var.repository_name) > 0
    error_message = "repository_name must not be empty."
  }
}

variable "policy" {
  description = "JSON lifecycle policy document"
  type        = string
  validation {
    condition     = length(var.policy) > 0
    error_message = "policy must not be empty."
  }
}
