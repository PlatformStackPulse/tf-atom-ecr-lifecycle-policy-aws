# Unit Tests for tf-atom-ecr-lifecycle-policy-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:      terraform test -test-directory=tests/unit
# Run verbose:   terraform test -test-directory=tests/unit -verbose
#
# Assertions target plan-KNOWN values only (tf-label id, resource counts,
# input pass-throughs, the enabled flag). Computed attributes such as the
# policy's registry_id are UNKNOWN under a mock provider and are therefore
# only asserted to be null in the disabled case.

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module's own required inputs
  repository_name = "eg-test-thing"
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ---------------------------------------------------------------------------
# Test: module creates the lifecycle policy when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled"
  }

  assert {
    condition     = length(aws_ecr_lifecycle_policy.this) == 1
    error_message = "exactly one aws_ecr_lifecycle_policy should be planned when enabled"
  }

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id should be 'eg-test-thing'"
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing and outputs null when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when the module is disabled"
  }

  assert {
    condition     = length(aws_ecr_lifecycle_policy.this) == 0
    error_message = "no aws_ecr_lifecycle_policy should be planned when disabled"
  }

  assert {
    condition     = output.repository == null
    error_message = "repository output should be null when disabled"
  }

  assert {
    condition     = output.registry_id == null
    error_message = "registry_id output should be null when disabled"
  }
}
