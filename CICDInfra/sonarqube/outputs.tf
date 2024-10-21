output "sonarqube_url" {
  description = "The URL to access SonarQube"
  value       = "http://${var.sonarqube_hostname}"
}

output "sonarqube_deployment_name" {
  value       = kubernetes_deployment.sonarqube.metadata[0].name
  description = "The name of the SonarQube deployment"
}

output "sonarqube_namespace" {
  description = "The namespace where SonarQube is deployed"
  value       = kubernetes_namespace.sonarqube.metadata[0].name
}

output "sonarqube_service_cluster_ip" {
  value       = kubernetes_service.sonarqube.spec[0].cluster_ip
  description = "The cluster IP address of the SonarQube service"
}

output "postgresql_service_name" {
  description = "The name of the PostgreSQL service"
  value       = kubernetes_service.postgresql.metadata[0].name
}

data "kubernetes_ingress_v1" "sonarqube_ingress" {
  metadata {
    name      = kubernetes_ingress_v1.sonarqube_ingress.metadata[0].name
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
  }

  depends_on = [kubernetes_ingress_v1.sonarqube_ingress]
}

output "sonarqube_ingress_ip" {
  description = "The IP address of the Ingress for SonarQube"
  value       = data.kubernetes_ingress_v1.sonarqube_ingress.status[0].load_balancer[0].ingress[0].ip
}

output "sonarqube_ingress_name" {
  description = "The name of the Ingress resource for SonarQube"
  value       = kubernetes_ingress_v1.sonarqube_ingress.metadata[0].name
}

output "sonarqube_service_name" {
  description = "The name of the SonarQube service"
  value       = kubernetes_service.sonarqube.metadata[0].name
}

output "sonarqube_ingress_ip_command" {
  description = "Command to get the SonarQube Ingress IP"
  value       = "kubectl get ingress ${kubernetes_ingress_v1.sonarqube_ingress.metadata[0].name} -n ${kubernetes_namespace.sonarqube.metadata[0].name} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
}

output "sonarqube_url_command" {
  description = "Command to get the SonarQube URL"
  value       = "echo http://$(kubectl get ingress ${kubernetes_ingress_v1.sonarqube_ingress.metadata[0].name} -n ${kubernetes_namespace.sonarqube.metadata[0].name} -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
}
