provider "google-beta" {
  project = var.gcp_project
  region  = var.region
  version = ">= 3.32"
}

provider "google" {
  project = var.gcp_project
  region  = var.region
  version = ">= 3.32"
}
provider "random" {
  version = "~> 2.2"
}
