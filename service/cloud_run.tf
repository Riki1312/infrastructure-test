locals {
  image = "${var.location}-docker.pkg.dev/${var.project}/${var.repository}/${var.name}-image:${var.tag}"
}

resource "google_cloud_run_service" "main" {
  name     = "service-${var.name}"
  location = var.location

  template {
    spec {
      containers {
        image = local.image

        ports {
          name           = "h2c"
          container_port = 8080
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = 0
        "autoscaling.knative.dev/maxScale" = "4"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  metadata {
    annotations = {
      "run.googleapis.com/client-name" = "terraform"
    }
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  project  = google_cloud_run_service.main.project
  location = google_cloud_run_service.main.location
  service  = google_cloud_run_service.main.name

  policy_data = data.google_iam_policy.noauth.policy_data

  depends_on = [
    google_cloud_run_service.main
  ]
}

output "service_url" {
  value       = google_cloud_run_service.main.status[0].url
  description = "Cloud Run service url"
}
