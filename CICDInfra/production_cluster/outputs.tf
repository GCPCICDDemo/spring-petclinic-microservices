output "cluster_name" {
  value       = google_container_cluster.production_cluster.name
  description = "The name of the cluster"
}

output "cluster_endpoint" {
  value       = google_container_cluster.production_cluster.endpoint
  description = "The endpoint for the cluster"
}

output "cluster_ca_certificate" {
  value       = google_container_cluster.production_cluster.master_auth[0].cluster_ca_certificate
  description = "The public certificate that is the root of trust for the cluster"
  sensitive   = true
}

output "location" {
  value       = google_container_cluster.production_cluster.location
  description = "The location of the cluster"
}

