variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "cicd_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "trivy_namespace" {
  description = "Kubernetes namespace for Trivy"
  type        = string
  default     = "trivy"
}

variable "trivy_chart_version" {
  description = "Version of the Trivy Helm chart"
  type        = string
}

variable "trivy_version" {
  description = "Version of Trivy to deploy"
  type        = string
}

variable "trivy_storage_size" {
  description = "Storage size for Trivy persistence"
  type        = string
  default     = "5Gi"
}

variable "trivy_cpu_request" {
  description = "CPU request for Trivy"
  type        = string
  default     = "100m"
}

variable "trivy_memory_request" {
  description = "Memory request for Trivy"
  type        = string
  default     = "512Mi"
}

variable "trivy_cpu_limit" {
  description = "CPU limit for Trivy"
  type        = string
  default     = "500m"
}

variable "trivy_memory_limit" {
  description = "Memory limit for Trivy"
  type        = string
  default     = "1Gi"
}

variable "trivy_hostname" {
  description = "Hostname for Trivy Ingress"
  type        = string
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}
