resource "aws_ecr_lifecycle_policy" "this" {
  count = module.this.enabled ? 1 : 0

  repository = var.repository_name
  policy     = var.policy
}
