# modules/gcp-services/main.tf

# Required GCP APIs:
# - compute.googleapis.com: For VPC and compute resources
# - container.googleapis.com: For GKE
# - containerregistry.googleapis.com: For container images
# - cloudbuild.googleapis.com: For building containers
# - iam.googleapis.com: For service accounts and permissions
# - logging.googleapis.com: For cluster logging
# - monitoring.googleapis.com: For cluster monitoring
# - stackdriver.googleapis.com: For observability
# - cloudtrace.googleapis.com: For tracing

# Note: APIs are not disabled on destroy to prevent disruption
# to other services

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