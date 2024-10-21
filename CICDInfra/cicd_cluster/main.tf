provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_compute_network" "default" {
  name = "default"
}

data "google_compute_subnetwork" "default" {
  name   = "default"
  region = var.region
}

resource "google_container_cluster" "cicd_cluster" {
  name     = var.cluster_name
  location = var.location
  
  network    = data.google_compute_network.default.name
  subnetwork = data.google_compute_subnetwork.default.name

  node_pool {
    name       = "custom-node-pool"
    
    autoscaling {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
    
    initial_node_count = var.initial_node_count

    node_config {
      machine_type = var.machine_type
      
      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/cloud-platform"
      ]

      labels = {
        env = var.project_id
      }

      tags = ["gke-node", "cicd-cluster"]
      
      metadata = {
        disable-legacy-endpoints = "true"
      }

      disk_size_gb = var.disk_size_gb
      disk_type    = var.disk_type
    }
  }
}
