output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "repository" {
  description = "Repository name the policy is attached to"
  value       = try(aws_ecr_lifecycle_policy.this[0].repository, null)
}

output "registry_id" {
  description = "Registry ID"
  value       = try(aws_ecr_lifecycle_policy.this[0].registry_id, null)
}
