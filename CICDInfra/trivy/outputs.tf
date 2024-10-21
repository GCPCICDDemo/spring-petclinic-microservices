output "trivy_namespace" {
  description = "The Kubernetes namespace where Trivy is deployed"
  value       = kubernetes_namespace.trivy.metadata[0].name
}

output "trivy_service_name" {
  description = "The name of the Trivy Kubernetes service"
  value       = "trivy"
}

output "trivy_ingress_hostname" {
  description = "The hostname for the Trivy Ingress"
  value       = var.trivy_hostname
}

output "trivy_version" {
  description = "The version of Trivy deployed"
  value       = var.trivy_version
}
output "trivy_hostname" {
  description = "The hostname for the Trivy Ingress"
  value       = var.trivy_hostname
}
