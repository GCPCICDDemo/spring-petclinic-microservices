variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  type        = string
}

variable "location" {
  description = "The location to host the cluster in"
  type        = string
}

variable "min_node_count" {
  description = "Minimum number of nodes in the NodePool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the NodePool"
  type        = number
  default     = 3
}

variable "initial_node_count" {
  description = "Initial number of nodes in the NodePool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "The name of a Google Compute Engine machine type"
  type        = string
  default     = "e2-medium"
}


variable "node_count" {
  description = "Number of nodes in the cluster"
}

variable "disk_size_gb" {
  description = "The disk size for the nodes"
}

variable "disk_type" {
  description = "The disk type for the nodes"
}
