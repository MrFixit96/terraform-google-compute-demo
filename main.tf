//--------------------------------------------------------------------
// Modules
module "compute" {
  source  = "app.terraform.io/janderton-sandbox/compute/google"
  version = "2.0.3"

  instance_name = var.instance_name
  preemptible = var.preemptible
  automatic_restart = var.automatic_restart
  project = var.project_id
  subnetwork_name = var.subnetwork_name
}
