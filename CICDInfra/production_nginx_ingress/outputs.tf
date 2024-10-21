data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
  }
  depends_on = [helm_release.ingress_nginx]
}

output "load_balancer_ip" {
  description = "The IP address of the load balancer for the NGINX Ingress controller"
  value       = data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.ip
}

