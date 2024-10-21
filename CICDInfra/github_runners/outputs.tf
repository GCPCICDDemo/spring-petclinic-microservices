output "github_runners_namespace" {
  description = "The namespace where GitHub Runners are deployed"
  value       = kubernetes_namespace.github_runners.metadata[0].name
}

output "actions_runner_controller_release_name" {
  description = "The name of the Helm release for Actions Runner Controller"
  value       = helm_release.actions_runner_controller.name
}

output "runner_deployment_name" {
  description = "The name of the RunnerDeployment"
  value       = kubernetes_manifest.runner_deployment.manifest.metadata.name
}

output "github_webhook_ingress_name" {
  description = "The name of the Ingress for GitHub webhook"
  value       = kubernetes_ingress_v1.github_webhook_ingress.metadata[0].name
}

output "github_webhook_url" {
  description = "The URL for the GitHub webhook"
  value       = "http://${var.github_webhook_hostname}"
}

output "github_webhook_ingress_ip_command" {
  description = "Command to get the GitHub webhook Ingress IP"
  value       = "kubectl get ingress ${kubernetes_ingress_v1.github_webhook_ingress.metadata[0].name} -n ${kubernetes_namespace.github_runners.metadata[0].name} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
}
