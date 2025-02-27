terraform {
  backend "gcs" {
    bucket = "lab11-446921-terraform-state"
    prefix = "terraform/state"
  }
}
