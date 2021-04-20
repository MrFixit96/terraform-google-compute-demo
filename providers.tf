terraform {
  backend "remote" {
  }
}

provider "google" {
  credentials = var.credential_file
  region      = var.region
  version     = ">=3.31.0"
}

provider "google-beta" {
  credentials = var.credential_file
  region      = var.region
  version     = ">=3.31.0"
}
