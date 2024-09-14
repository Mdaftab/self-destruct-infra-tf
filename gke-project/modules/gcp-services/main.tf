# modules/gcp-services/main.tf

resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudtrace.googleapis.com"
  ])

  service = each.key

  disable_on_destroy = false
}

# modules/gcp-services/variables.tf

# No variables needed for this module

# modules/gcp-services/outputs.tf

# No outputs needed for this module