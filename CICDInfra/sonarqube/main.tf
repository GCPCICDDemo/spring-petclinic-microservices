provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

data "google_container_cluster" "cicd_cluster" {
  name     = var.cluster_name
  location = var.cluster_location
  project  = var.project_id
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.cicd_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.cicd_cluster.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name = var.namespace
  }
}

# PostgreSQL Deployment
resource "kubernetes_deployment" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgresql"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgresql"
        }
      }

      spec {
        init_container {
          name  = "init-postgresql-data"
          image = "busybox"
          command = [
            "sh",
            "-c",
            "mkdir -p /var/lib/postgresql/data/pgdata && chown -R 999:999 /var/lib/postgresql/data"
          ]
          security_context {
            run_as_user = 0
          }
          volume_mount {
            name       = "postgresql-data"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgresql"
          }
        }

        container {
          image = "postgres:13"
          name  = "postgresql"

          env {
            name  = "POSTGRES_DB"
            value = var.db_name
          }
          env {
            name  = "POSTGRES_USER"
            value = var.db_username
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.db_password
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgresql-data"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgresql"
          }
        }

        volume {
          name = "postgresql-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgresql_data.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgresql_data" {
  metadata {
    name      = "postgresql-data-new"
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}

resource "kubernetes_service" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
  }
  spec {
    selector = {
      app = "postgresql"
    }
    port {
      port        = 5432
      target_port = 5432
    }
    cluster_ip = "None"
  }
}

# SonarQube Deployment
resource "kubernetes_deployment" "sonarqube" {
  metadata {
    name      = "sonarqube"
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "sonarqube"
      }
    }

    template {
      metadata {
        labels = {
          app = "sonarqube"
        }
      }

      spec {
        init_container {
          name  = "init-sysctl"
          image = "busybox"
          command = [
            "sh",
            "-c",
            "mkdir -p /opt/sonarqube/data && chown -R 1000:1000 /opt/sonarqube/data"
          ]
          security_context {
            run_as_user = 0
          }
          volume_mount {
            name       = "sonarqube-data"
            mount_path = "/opt/sonarqube/data"
          }
        }

        container {
          image = "sonarqube:${var.sonarqube_version}"
          name  = "sonarqube"

          env {
            name  = "SONARQUBE_JDBC_USERNAME"
            value = var.db_username
          }
          env {
            name  = "SONARQUBE_JDBC_PASSWORD"
            value = var.db_password
          }
          env {
            name  = "SONARQUBE_JDBC_URL"
            value = "jdbc:postgresql://postgresql:5432/${var.db_name}"
          }

          port {
            container_port = 9000
          }

          security_context {
            run_as_user = 1000
          }

          volume_mount {
            name       = "sonarqube-data"
            mount_path = "/opt/sonarqube/data"
          }
        }

        volume {
          name = "sonarqube-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.sonarqube_data.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "sonarqube_data" {
  metadata {
    name      = "sonarqube-data"
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}

resource "kubernetes_service" "sonarqube" {
  metadata {
    name      = "sonarqube"
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
  }
  spec {
    selector = {
      app = "sonarqube"
    }
    port {
      port        = 80
      target_port = 9000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "sonarqube_ingress" {
  metadata {
    name      = "sonarqube-ingress"
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                 = var.ingress_class
      "nginx.ingress.kubernetes.io/proxy-body-size" = "64m"
    }
  }

  spec {
    rule {
      host = var.sonarqube_hostname  # Add this line
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.sonarqube.metadata[0].name
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
