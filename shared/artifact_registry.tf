resource "google_artifact_registry_repository" "docker" {
  provider = google-beta

  location      = var.location
  repository_id = var.repository
  description   = "Docker repository"
  format        = "DOCKER"

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

output "repository_name" {
  value       = google_artifact_registry_repository.docker.name
  description = "Artifact Registry repository name"
}
