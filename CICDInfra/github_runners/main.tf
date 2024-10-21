terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.2"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

data "google_container_cluster" "cicd_cluster" {
  name     = var.cluster_name
  location = var.cluster_location
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.cicd_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.cicd_cluster.master_auth[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.cicd_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.cicd_cluster.master_auth[0].cluster_ca_certificate)
  }
}

resource "kubernetes_namespace" "github_runners" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = true
  version          = "v1.13.0"  # Use the latest version available

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "time_sleep" "wait_for_cert_manager" {
  depends_on = [helm_release.cert_manager]

  create_duration = "30s"
}

resource "helm_release" "actions_runner_controller" {
  name       = "actions-runner-controller"
  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  namespace  = kubernetes_namespace.github_runners.metadata[0].name
  version    = "0.22.0"

  set {
    name  = "authSecret.create"
    value = "true"
  }

  set {
    name  = "authSecret.github_app_id"
    value = var.github_app_id
  }

  set {
    name  = "authSecret.github_app_installation_id"
    value = var.github_app_installation_id
  }

  set {
    name  = "authSecret.github_app_private_key"
    value = var.github_app_private_key
  }

  set {
    name  = "githubWebhookServer.enabled"
    value = "true"
  }

  set {
    name  = "githubWebhookServer.secret.github_webhook_secret_token"
    value = var.github_webhook_secret_token
  }

  depends_on = [helm_release.cert_manager, time_sleep.wait_for_cert_manager]
}

resource "kubernetes_manifest" "runner_deployment" {
  manifest = {
    apiVersion = "actions.summerwind.dev/v1alpha1"
    kind       = "RunnerDeployment"
    metadata = {
      name      = "github-runners"
      namespace = kubernetes_namespace.github_runners.metadata[0].name
    }
    spec = {
      replicas = var.runner_replicas
      template = {
        spec = {
          organization = var.github_org
          labels       = ["self-hosted", "linux", "x64"]
        }
      }
    }
  }

  depends_on = [helm_release.actions_runner_controller]
}

resource "kubernetes_ingress_v1" "github_webhook_ingress" {
  metadata {
    name      = "github-webhook-ingress"
    namespace = kubernetes_namespace.github_runners.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"  # Add this if you want to allow HTTP
    }
  }

  spec {
    rule {
      host = var.github_webhook_hostname
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "actions-runner-controller-github-webhook-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
