##############################################################################
variable "m_repo_tfstate_backend_project" {
  type        = string
  description = "(R) GCP Project Id"
}
variable "m_repo_tfstate_backend_bucket" {
  type        = string
  description = "(R) Name of State GCS Bucket"
}

##############################################################################
resource "google_storage_bucket" "repo_tfstate_backend_bucket" {
  name                        = var.m_repo_tfstate_backend_bucket
  project                     = var.m_repo_tfstate_backend_project
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
  labels = { #                    remember label LIMITATIONS  [a-z0-9_-]{63}
    "createdby" = "terraform_${local.now}"
    "name"      = var.m_repo_tfstate_backend_bucket
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      num_newer_versions = "50"
    }
    action {
      type = "Delete"
    }
  }
}

##############################################################################
output "repo_tfstate_backend_bucket_url" {
  value = google_storage_bucket.repo_tfstate_backend_bucket.url
}

##############################################################################
##############################################################################
##############################################################################
terraform {
  required_version = ">=0.14.8"
  required_providers {
    google = "<4.0,>= 3.64"
  }
}
locals {
  now = formatdate("YYYY-MM-DD", timestamp())
}