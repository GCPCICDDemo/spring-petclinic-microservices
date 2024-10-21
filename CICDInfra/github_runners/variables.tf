variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "cluster_location" {
  description = "The location of the GKE cluster"
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace for GitHub Runners"
  type        = string
  default     = "github-runners"
}

variable "github_app_id" {
  description = "The GitHub App ID"
  type        = string
}

variable "github_app_installation_id" {
  description = "The GitHub App Installation ID"
  type        = string
}

variable "github_app_private_key" {
  description = "The GitHub App Private Key"
  type        = string
}

variable "github_webhook_secret_token" {
  description = "The GitHub Webhook Secret Token"
  type        = string
}

variable "github_org" {
  description = "The GitHub organization name"
  type        = string
}

variable "runner_replicas" {
  description = "The number of runner replicas"
  type        = number
  default     = 1
}

# Add this to the existing variables
variable "github_webhook_hostname" {
  description = "The hostname for the GitHub webhook"
  type        = string
}
