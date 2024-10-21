provider "google" {
  project = var.project_id
  region  = var.region
}

# Artifact Registry for Docker
resource "google_artifact_registry_repository" "docker_local" {
  location      = var.region
  repository_id = "docker-local"
  description   = "Docker local repository"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "docker_remote" {
  location      = var.region
  repository_id = "docker-remote"
  description   = "Docker remote repository (proxy for Docker Hub)"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "Docker Hub"
    docker_repository {
      public_repository = "DOCKER_HUB"
    }
  }
}

resource "google_artifact_registry_repository" "docker" {
  location      = var.region
  repository_id = "docker"
  description   = "Docker virtual repository"
  format        = "DOCKER"
  mode          = "VIRTUAL_REPOSITORY"
  virtual_repository_config {
    upstream_policies {
      id         = "docker-local"
      repository = google_artifact_registry_repository.docker_local.id
      priority   = 1
    }
    upstream_policies {
      id         = "docker-remote"
      repository = google_artifact_registry_repository.docker_remote.id
      priority   = 2
    }
  }
}

# Artifact Registry for Maven
resource "google_artifact_registry_repository" "maven_local" {
  location      = var.region
  repository_id = "maven-local"
  description   = "Maven local repository"
  format        = "MAVEN"
}

resource "google_artifact_registry_repository" "maven_remote" {
  location      = var.region
  repository_id = "maven-remote"
  description   = "Maven remote repository (proxy for Maven Central)"
  format        = "MAVEN"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "Maven Central"
    maven_repository {
    }
  }
}

resource "google_artifact_registry_repository" "maven" {
  location      = var.region
  repository_id = "maven"
  description   = "Maven virtual repository"
  format        = "MAVEN"
  mode          = "VIRTUAL_REPOSITORY"
  virtual_repository_config {
    upstream_policies {
      id         = "maven-local"
      repository = google_artifact_registry_repository.maven_local.id
      priority   = 1
    }
    upstream_policies {
      id         = "maven-remote"
      repository = google_artifact_registry_repository.maven_remote.id
      priority   = 2
    }
  }
}
