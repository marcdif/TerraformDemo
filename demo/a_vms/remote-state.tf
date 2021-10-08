######################################
### Terraform Provider Information ###
######################################
terraform {
  backend "gcs" {
    bucket = "mdifilippo-tfstate-bucket"
    prefix = "demo/vms"
  }
}