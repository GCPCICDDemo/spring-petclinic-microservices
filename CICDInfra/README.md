# GCPCICD: CI/CD Infrastructure on Google Cloud Platform

## Overview

This repository contains Terraform configurations for setting up and managing CI/CD infrastructure on Google Cloud Platform (GCP). It includes configurations for a CICD cluster, Artifact Registry, staging and production GKE clusters, and CI/CD tools deployment.

## Repository Structure

```
CICDInfra/
├── cicd_cluster/
├── artifact_registry/
├── github_runners/
├── sonarqube/
├── trivy/
├── argocd/
├── cicd_nginx_ingress/
├── staging_nginx_ingress/
├── prod_nginx_ingress/
├── staging_cluster/
├── production_cluster/
└── README.md
```

### Components

- `cicd_cluster`: Configuration for the dedicated GKE cluster to host CI/CD tools
- `artifact_registry`: Configuration for setting up Google Artifact Registry for Docker and Maven
- `github_runners`: Configuration for deploying GitHub Actions runners
- `sonarqube`: Configuration for deploying SonarQube
- `trivy`: Configuration for deploying Trivy
- `argocd`: Configuration for deploying ArgoCD
- `cicd_nginx_ingress`: Configuration for NGINX Ingress on the CICD cluster
- `staging_nginx_ingress`: Configuration for NGINX Ingress on the staging cluster
- `prod_nginx_ingress`: Configuration for NGINX Ingress on the production cluster
- `staging_cluster`: Configuration for the staging GKE cluster
- `production_cluster`: Configuration for the production GKE cluster

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (version 0.14.0 or later)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- A Google Cloud Platform account with necessary permissions

## Setup

1. Clone this repository:
   ```
   git clone <REPO_URL>
   cd CICDInfra
   ```

2. Authenticate with Google Cloud:
   ```
   gcloud auth application-default login
   ```

3. Update the `terraform.tfvars` files in each component directory with your specific GCP project details and desired configurations.

## Usage

### CICD GKE Cluster

To set up the GKE cluster:

1. Navigate to the cicd_cluster directory:
   ```
   cd CICDInfra/cicd_cluster
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Review the planned changes:
   ```
   terraform plan
   ```

4. Apply the changes:
   ```
   terraform apply
   ```

### Artifact Registry

To set up the Artifact Registry:

1. Navigate to the artifact_registry directory:
   ```
   cd CICDInfra/artifact_registry
   ```

2. Follow the same steps as for the CICD cluster (init, plan, apply).

### GitHub Runners, SonarQube, and Trivy

Follow the same process for each of these components, navigating to their respective directories and running the Terraform commands.

## CI/CD Integration

This infrastructure is designed to be used with CI/CD pipelines. The GitHub Actions runners are deployed directly to the CICD cluster, allowing for seamless integration with your GitHub repositories.

## Best Practices

- Keep `terraform.tfvars` files out of version control to protect sensitive information
- Use remote state storage (e.g., Google Cloud Storage) for collaboration and better security
- Regularly update your Terraform version and provider versions
- Use consistent naming conventions across all resources
- Implement proper IAM roles and permissions for least privilege access

## Troubleshooting

- If you encounter permission issues, ensure your GCP account has the necessary roles assigned
- For "resource already exists" errors, check if the resource was created outside of Terraform and import it if necessary
- Use `terraform console` for debugging and testing expressions

## Maintenance

- Regularly update the GitHub runner images and other tool versions
- Monitor the usage and performance of your CICD cluster and scale as necessary
- Periodically review and update IAM permissions to ensure they adhere to the principle of least privilege
- Keep your Terraform configurations and modules up to date with the latest best practices and features

## Security Considerations

- Ensure that access to the CICD cluster is properly restricted
- Use secrets management for sensitive data such as GitHub tokens
- Regularly scan your infrastructure and container images for vulnerabilities using Trivy
- Implement network policies in your GKE cluster to control pod-to-pod communication

## Contributing

Contributions to improve the infrastructure setup are welcome. Please follow these steps:

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to your branch
5. Create a new Pull Request

## Terraform Variables

### CICD NGINX Ingress

| Variable Name | Description | Sample Value |
|---------------|-------------|--------------|
| project_id | GCP Project ID | "my-project-id" |
| region | GCP Region | "us-central1" |
| cluster_name | Name of the CICD GKE cluster | "cicd-cluster" |
| ingress_namespace | Kubernetes namespace for NGINX Ingress | "ingress-nginx" |
| ingress_chart_version | Version of the NGINX Ingress Helm chart | "4.0.13" |

### Staging NGINX Ingress

| Variable Name | Description | Sample Value |
|---------------|-------------|--------------|
| project_id | GCP Project ID | "my-project-id" |
| region | GCP Region | "us-central1" |
| cluster_name | Name of the staging GKE cluster | "staging-cluster" |
| ingress_namespace | Kubernetes namespace for NGINX Ingress | "ingress-nginx" |
| ingress_chart_version | Version of the NGINX Ingress Helm chart | "4.0.13" |

### Production NGINX Ingress

| Variable Name | Description | Sample Value |
|---------------|-------------|--------------|
| project_id | GCP Project ID | "my-project-id" |
| region | GCP Region | "us-central1" |
| cluster_name | Name of the production GKE cluster | "prod-cluster" |
| ingress_namespace | Kubernetes namespace for NGINX Ingress | "ingress-nginx" |
| ingress_chart_version | Version of the NGINX Ingress Helm chart | "4.0.13" |

### Staging Cluster

| Variable Name | Description | Sample Value |
|---------------|-------------|--------------|
| project_id | GCP Project ID | "my-project-id" |
| region | GCP Region | "us-central1" |
| cluster_name | Name of the staging GKE cluster | "staging-cluster" |
| node_count | Number of nodes in the cluster | 3 |
| machine_type | Machine type for cluster nodes | "e2-standard-2" |

### Production Cluster

| Variable Name | Description | Sample Value |
|---------------|-------------|--------------|
| project_id | GCP Project ID | "my-project-id" |
| region | GCP Region | "us-central1" |
| cluster_name | Name of the production GKE cluster | "prod-cluster" |
| node_count | Number of nodes in the cluster | 5 |
| machine_type | Machine type for cluster nodes | "e2-standard-4" |
