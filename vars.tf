variable "instance_name" {
  default = "tfe-gce-demo"
  description = "The name for the GCP Instance being provisioned"
}

variable "preemptible" {
  default = "false"
  description = "Whether or not this is a preemptible instance."
}

variable "automatic_restart" {
  default = true
  description = "Whether or not to automatically restart the instance"
} 

variable "on_host_maintenance" {
  description = "(Optional) Describes maintenance behavior for the instance. Can be MIGRATE or TERMINATE"
  default     = "MIGRATE"
}

variable "subnetwork_name" {
  default = "default"
  description = "The name of the subnetwork to attach the instance to."
}

variable "region" {
  default = "us-central1"
  description = "The region to provision to"
}

variable "project_id" {
  default = "my-project"
  description = "The Google Cloud Project ID to provision in to."
}

variable "credential_file" {
  description = "The Google Cloud service account key to use."
}
