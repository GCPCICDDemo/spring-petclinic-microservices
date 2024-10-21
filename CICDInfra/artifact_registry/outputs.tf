output "docker_local_repo_url" {
  value       = google_artifact_registry_repository.docker_local.name
  description = "The URL of the Docker local repository"
}

output "docker_remote_repo_url" {
  value       = google_artifact_registry_repository.docker_remote.name
  description = "The URL of the Docker remote repository"
}

output "docker_repo_url" {
  value       = google_artifact_registry_repository.docker.name
  description = "The URL of the Docker virtual repository"
}

output "maven_local_repo_url" {
  value       = google_artifact_registry_repository.maven_local.name
  description = "The URL of the Maven local repository"
}

output "maven_remote_repo_url" {
  value       = google_artifact_registry_repository.maven_remote.name
  description = "The URL of the Maven remote repository"
}

output "maven_repo_url" {
  value       = google_artifact_registry_repository.maven.name
  description = "The URL of the Maven virtual repository"
}

output "docker_local_repository_name" {
  value       = google_artifact_registry_repository.docker_local.name
  description = "The name of the Docker local repository"
}

output "docker_remote_repository_name" {
  value       = google_artifact_registry_repository.docker_remote.name
  description = "The name of the Docker remote repository"
}

output "docker_repository_name" {
  value       = google_artifact_registry_repository.docker.name
  description = "The name of the Docker virtual repository"
}

output "maven_local_repository_name" {
  value       = google_artifact_registry_repository.maven_local.name
  description = "The name of the Maven local repository"
}

output "maven_remote_repository_name" {
  value       = google_artifact_registry_repository.maven_remote.name
  description = "The name of the Maven remote repository"
}

output "maven_repository_name" {
  value       = google_artifact_registry_repository.maven.name
  description = "The name of the Maven virtual repository"
}
