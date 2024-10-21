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
  description = "The Kubernetes namespace for SonarQube"
  type        = string
  default     = "sonarqube"
}

variable "db_name" {
  description = "The name of the PostgreSQL database for SonarQube"
  type        = string
  default     = "sonarqube"
}

variable "db_username" {
  description = "The username for the PostgreSQL database"
  type        = string
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
}

variable "storage_size" {
  description = "The size of the persistent volume claims"
  type        = string
  default     = "10Gi"
}

variable "storage_class" {
  description = "The storage class for the persistent volume claims"
  type        = string
  default     = "standard"
}

variable "sonarqube_version" {
  description = "The version of SonarQube to deploy"
  type        = string
  default     = "9.9-community"
}

variable "ingress_class" {
  description = "Ingress class to use for SonarQube"
  type        = string
  default     = "nginx"
}

variable "sonarqube_hostname" {
  description = "The hostname for SonarQube"
  type        = string
}
