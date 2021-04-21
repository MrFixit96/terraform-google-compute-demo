terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.24.0"
    }
  }
}


resource "tfe_organization" "sandbox" {
  name  = "${var.tfe_org}-sandbox"
  email = var.email

  lifecycle {
    prevent_destroy = true
  }

}

resource "tfe_workspace" "ws" {
  for_each = toset(var.workspaces.name)

  name              = "jca-tfe-testing-${each.value}"
  organization      = "${var.tfe_org}-sandbox"
  auto_apply        = false
  trigger_prefixes  = []
  working_directory = ""
  operations        = true
  vcs_repo {
    identifier         = var.workspaces.vcs_repo.identifier
    branch             = var.workspaces.vcs_repo.branch
    ingress_submodules = var.workspaces.vcs_repo.ingress_submodules
    oauth_token_id     = var.workspaces.vcs_repo.oauth_token_id
  }
}

resource "tfe_variable" "credentials" {
  for_each     = tfe_workspace.ws
  key          = "credential_file"
  value        = file(var.credential_file)
  category     = "terraform"
  workspace_id = each.value.id
  description  = "GCP Service Account Creds for Terraform"
  sensitive    = true
}

resource "tfe_variable" "billing_account" {
  for_each     = tfe_workspace.ws
  key          = "billing_account"
  value        = var.billing_account
  category     = "terraform"
  workspace_id = each.value.id
  description  = "GCP Billing Account ID for Hashicorp EA Team"
  sensitive    = true
}

resource "tfe_variable" "tfe_token" {
  for_each     = tfe_workspace.ws
  key          = "TFE_TOKEN"
  value        = var.workspaces.vcs_repo.oauth_token_id
  category     = "terraform"
  workspace_id = each.value.id
  description  = "TFE Token required to modify the workspace using remote backend https://github.com/terraform-providers/terraform-provider-tfe/issues/102"
  sensitive    = true
}

