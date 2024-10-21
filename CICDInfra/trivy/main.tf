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
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

data "google_container_cluster" "cicd_cluster" {
  name     = var.cicd_cluster_name
  location = var.region
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

resource "kubernetes_namespace" "trivy" {
  metadata {
    name = var.trivy_namespace
  }
}

resource "helm_release" "trivy" {
  name       = "trivy"
  repository = "https://aquasecurity.github.io/helm-charts/"
  chart      = "trivy"
  namespace  = kubernetes_namespace.trivy.metadata[0].name
  version    = var.trivy_chart_version

  set {
    name  = "trivy.repository"
    value = "aquasec/trivy"
  }

  set {
    name  = "trivy.tag"
    value = var.trivy_version
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.className"
    value = var.ingress_class_name
  }

  set {
    name  = "ingress.hosts[0].host"
    value = var.trivy_hostname
  }

  set {
    name  = "ingress.hosts[0].paths[0].path"
    value = "/"
  }

  set {
    name  = "ingress.hosts[0].paths[0].pathType"
    value = "Prefix"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = var.trivy_storage_size
  }

  set {
    name  = "resources.requests.cpu"
    value = var.trivy_cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.trivy_memory_request
  }

  set {
    name  = "resources.limits.cpu"
    value = var.trivy_cpu_limit
  }

  set {
    name  = "resources.limits.memory"
    value = var.trivy_memory_limit
  }
}
