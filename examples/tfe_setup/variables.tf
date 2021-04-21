variable "env" {
  description = "A Prefix to add to names"
}

variable "tfe_org" {
  description = "The name of the terraform org to create a workspace under"
}

variable "email" {
  description = "The email address used for the account to log into Terraform Cloud"
}

variable "oauth_token" {
  description = "The Github oAuth Token to use for VCS backed Workspaces (Provide this via CLI ENV / Vault Provider)"
}

variable "tfe_host" {
  description = "The TFE URL to connect to"
  default     = "app.terraform.io"
}

variable "tfe_token" {
  description = "The TFE Org Token to authenticate with"
}

variable "credential_file" {
  description = "The GCP Service Account Credentials JSON file name to provision with"
}

variable "billing_account" {
  description = "The GCP Billing Account ID for this project"
}

variable "prefix_project_setup" {
  description = "The name of the gcp setup stage to create. This is used to build the workspace name"
}

variable "prefix_platform_setup" {
  description = "The name of the gcp setup stage to create. This is used to build the workspace name"
}

variable "prefix_admin_setup" {
  description = "The name of the gcp setup stage to create. This is used to build the workspace name"
}

variable "prefix_app_setup" {
  description = "The name of the gcp setup stage to create. This is used to build the workspace name"
}

variable "workspaces" {
  description = "The name of the TFE workspace we are creating"
}

#variable "workspace_list" {
#  description = "A list of names of the TFE workspaces we are creating"
#}
