########################################################
#####Project setup info
#   Vars for creating project level related resource
#   (ie. vpc, firewall rules, vpc-peering, etc.)

#### Uncomment this if not using our makefiles
#terraform_workspace = "sandbox_setup"

# Terraform Enterprise info
tfe_org = "janderton"
tfe_host = "app.terraform.io"
email   = "janderton@hashicorp.com"

env = "dev"
project_name = "jca-tfe-testing"
project_id = "jca-tfe-testing-1da3236b"
billing_account = "01340E-ED8E31-9FCA36"
credential_file = "/home/janderton/source/creds/jca-tf-testing-c4ea56a23af5.json"
region = "us-central1"
prefix_tfe_setup = "TFE-DEMO-tfe_setup"
prefix_org_setup = "jca-tfe-testing-org_setup"
prefix_project_setup = "jca-tfe-testing-project_setup"
prefix_platform_setup = "jca-tfe-testing-platform_setup"
prefix_org_policies = "jca-tfe-testing-org_policies"
prefix_admin_setup = "jca-tfe-testing-admin_setup"
prefix_app_setup = "jca-tfe-testing-app_setup"
state_bucket_name = "jca-tfstate-hashicorp"
state_project_name = "jca-tf-testing"
workspaces = { 
  "name"              = ["compute_demo"]
  "working_directory" = []
  "vcs_repo"          = {
    "identifier"         = "mrfixit96/terraform-google-compute-demo"
    "branch"             = "main"
    "ingress_submodules" = true
    "oauth_token_id"     = "ot-SkuwfW6uGhQV1CZq"
  } 
}

