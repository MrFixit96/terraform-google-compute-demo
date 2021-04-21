//--------------------------------------------------------------------
// Modules
module "compute" {
  source  = "app.terraform.io/janderton-sandbox/compute/google"
  version = "2.0.3"

  instance_name = "tfe-gce-demo"
  preemptible = "true"
  project = "jca-tfe-testing-1da3236b"
  subnetwork_name = "sm-tfe-gcp-core-private"
}
