variable "project" {
  type        = string
  description = "Google Cloud project id"
}

variable "location" {
  type        = string
  description = "Cloud Run service location"
}

variable "repository" {
  type        = string
  description = "Artifact Registry repository id"
  default     = "docker-repository"
}

variable "prevent_destroy" {
  type        = bool
  description = "Prevent resources destroy"
  default     = true
}
