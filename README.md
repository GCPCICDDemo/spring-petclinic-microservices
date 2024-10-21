# Spring PetClinic Microservices with GCP CICD

This project demonstrates a GCP-based CI/CD pipeline for a microservices architecture using the Spring PetClinic application. It showcases best practices for branching strategies and continuous integration/deployment workflows.

## Branching Strategy

We follow branching strategy with the following branches:

### Main Branch (`main`)
- The main branch represents the latest production-ready state of the project.
- It is always stable and deployable.
- Direct commits to `main` are not allowed; changes are merged through pull requests.
- Branch protection rules and build checks are added to make sure the buildable deployable code is always present in the main branch.

### Release Branches (`release-*`)
- Created from `main` when preparing a new production release.
- Direct commits to `release-*` are not allowed; changes are merged through pull requests.
- Used for last-minute bug fixes and preparation for release.
- Merged back into `main` and tagged with a version number when ready for production.
- Naming convention: `release-X.Y.Z` (e.g., `release-1.2.0`)
- Branch protection rules and build checks are added to make sure the buildable deployable code is always present in the main branch.
- Release branch is deployed on staging env. and verification is performed before it is deployed into production.

### Feature Branches (`feature-*`)
- Created for developing new features or enhancements.
- Branched off from `main` and merged back via pull request when complete.
- Naming convention: `feature-short-description` (e.g., `feature-add-payment-gateway`)
- Build checks enabled to make sure buildable code is present.
- Feature branches are merged to particular release in which we intend to deliver the feature
  

### Hotfix Branches (`hotfix-*`)
- Used to quickly patch production releases.
- Branched off from the corresponding release tag on `main`.
- Merged back into both `main` and the current `release-*` branch.
- Naming convention: `hotfix-X.Y.Z+1` (e.g., `hotfix-1.2.1`)

## Feature Development Workflow

1. Create a new `feature-*` branch from `main`.
2. Develop and commit changes to the feature branch.
3. Open a pull request to merge the feature branch into `release-x.y.z`.
4. After code review and approval, merge the pull request.
5. The feature is now in `release-x.y.z` and will be included in the next release.
6. Once verification on staging is performed (Auotmated Tests + Manual Tests + Security Tests) and the quality is as required the rel;ease branch will be deployed on production.
7. If production deployment is good and no roleback needed (until a grace period ) then release-x.y.z branch is merged to main.
8. if production release has any issues role back is perfoemd using main branch (last release docker tags) and release branch verificaiton and issue triage follows.
9. In case of grace period for production deployment is over and new issues identifed Hot fized will be provided from hotfix branch
 

## CI/CD Pipeline

Our CI/CD pipeline is implemented using GitHub Actions and is defined in the `.github/workflows/ci-build.yml` file. The pipeline behaves differently based on the branch:

### Feature Branches (`feature-*`)
- Triggered on push to `feature-*` branches.
- Builds the project and runs unit tests.
- Performs static code analysis with SonarQube.(Currently set to ignore failures just for demo)
- Builds Docker images but does not push them.
- Runs vulnerability scans on the Docker images.(Currently set to ignore failures just for demo)
refer pipeline code: .github/workflows/ci-build.yaml

### Main Branch (`main`)
- Triggered on pull request to `main`.
- Performs the same steps as feature branches.
- Additionally, runs integration tests.
refer pipeline code: .github/workflows/ci-build.yaml

### Release and Hotfix Branches (`release-*`, `hotfix-*`)
- Triggered on push to `release-*` or `hotfix-*` branches.
- Performs all previous steps.
- Builds and pushes Docker images to Google Artifact Registry.
- Deploys to the staging environment for final testing.
For CI refer pipeline code: .github/workflows/ci-build.yaml
For CD refer /azure_devops_pipeline/

### Production Deployment
- Triggered manually after approval of a release.
- Deploys the approved release to the production environment.

### Artifacts  Management
There are 3 different repository created for each artifacts type (like maven, docker etc)
1. **Local Repository**: This repository is used to store the built artifacts such as java snapshot files, different libs created by the code base, docker images etc. This local repository is used as backing repository for a virtual repository.
2. **Remote Repository**: This repository has configured with different public repostory to cache the artifact that are used by application such as libs, base docker images etc. usually central maven, docker io , gcr repository can be configured in remote repository. This repository is also configured in Virtual reposiotry.
3. **Virtual Repository**: This repository has configured with local repository and remote repoistory. It is the repository which should be cnofigured everywhere as unified repository leveraging cached remote artifacts and locally build artifacts. This enables faster and reliable builds and inc ase of public repository rate limit or un availbility


### CI:

CI Job is Github Action based CI pipeline which is used to build the source code and create docker images 
file: .github/workflows/ci-build.yaml

### CD:
CD Pieplines are built for AzureDevOps 
File: /azure_devops_pipeline/staging-pipeline.yml, /azure_devops_pipeline/production-pipeline.yml

### Deployment Yaml files:
Deployment yaml files are used to deploy the micro services on to kubernetes.
file: /kubernetes

### Infrastructure
Refer Readme file in **CICDInfra** directory.

### Security Considerations
This demo provides basic security features mainly SAST (Static Application Security Testing) using SonarQube and Anchore
SonarQube provides source code scanning where as ANchore provides docker image vulnerability scanning. DAST testing is excluded however CIS bench marking test for infra , Pen Test for application is important aspect to consider.
TLS certificate terminating atleast at ingress is required.(its also better to use it for service to service communication specially when they are deployed in different AZ/region)
Also Having WAF(Web Application firewall), DDoS protection Shild , various IAM solutions required to secure the application.

### Scaling and High Availability 
In order to scale the application we can leverage both vertical as well as horizontal scaling(inlcuding scaling of udnerlying clusters). 
For application scaling HPA can provide better solution based on various metrics such as CPU utilization or other custom metrics. also implemnentaion of load balncer streamlines traffic and enable efficiancy.
For infra structure scaling auto scaling in GKE cluster can be utilized. Adding multiple node pool in various zones can enable proper horizontal scaling.
For availblity regional level fail over is prefererd and at least multi AZ deployment should be done.

### Monitoring and logging
This application leverages promethius and grfana based monitoring. 

### Database 
Though current application uses in memory database it is possible to add mysql databse. For finiance related and mission critical apps it is better to use DB as service from various cloud providers with Active + Active (sync/async) or Active + passive Synchromnization. It is not recmonnded to put Statefull application such as mysql on kubernertes.



Note About Original Application:
Original open source application used for the demo from: https://github.com/spring-petclinic/spring-petclinic-microservices
Updated the forked repo for fixes to application so that it can be deployed and run

## Microservices Overview

This project consists of several microservices:
- **Customers Service**: Manages customer data.
- **Vets Service**: Handles information about veterinarians.
- **Visits Service**: Manages pet visit records.
- **API Gateway**: Routes client requests to the appropriate services.
- **Config Server**: Centralized configuration management for all services.
- **Discovery Server**: Eureka-based service registry.

Each service has its own specific role and communicates via REST APIs.


![Spring Petclinic Microservices screenshot](docs/application-screenshot.png)


**Architecture diagram of the Spring Petclinic Microservices**

![Spring Petclinic Microservices architecture](docs/microservices-architecture-diagram.jpg)





[Configuration repository]: https://github.com/spring-petclinic/spring-petclinic-microservices-config
[Spring Boot Actuator Production Ready Metrics]: https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-metrics.html
