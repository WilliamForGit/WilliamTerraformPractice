WilliamTerraformPractice

A production-shaped Azure platform for running .NET microservices on AKS, built end-to-end with Terraform and deployed automatically via GitHub Actions.

This is a self-directed portfolio project. The goal is to demonstrate the kind of platform engineering work I'd do in a real team:
infrastructure as code, secure CI/CD, sensible scoping, and honest architectural trade-offs.

What's in the platform
Identity & CI/CD:   GitHub Actions + OIDC federated credentials   (Passwordless deployments from GitHub to Azure)

State:  Azure Storage (rg-tfstate) This is for Terraform remote state, isolated from platform resources

Compute:    AKS cluster (aks-wtp-dev)   2× Standard_B2als_v2 nodes, Sweden Central, Kubernetes 1.35

Registry:   Azure Container Registry (Basic)    Private image registry, attached to AKS via managed identity

Ingress:    NGINX Ingress Controller + cert-manager     External traffic entry with static public IP, TLS-ready

Data:   PostgreSQL Flexible Server (Free tier)      Can be used for backing store for microservices

Messaging:  Azure Service Bus(Basic)       Async event bus between services

Secrets:    Azure Key Vault     Central secret store, RBAC-authorized, CSI driver into pods

Observability:  Log Analytics + Application Insights    Cluster + application telemetry, workspace-based


Architecture
Internet
   │
   ▼
Azure Load Balancer (static public IP)
   │
   ▼
NGINX Ingress Controller (2 replicas, ingress-nginx namespace)
   │
   ▼
.NET microservices (each with Ingress rule for path-based routing)
   │
   ├──► PostgreSQL Flexible Server (managed)
   ├──► Service Bus (async events)
   ├──► Key Vault (secrets via CSI driver)
   └──► App Insights (traces & metrics)

All infrastructure is declared in Terraform. All deployments go through GitHub Actions with OIDC 
— there are no long-lived credentials anywhere in the repository or the CI/CD system.

.
├── infra/                        Terraform for the entire platform
│   ├── main.tf                   Providers + AzureRM backend
│   ├── variables.tf              Input variables (location, project name, environment)
│   ├── outputs.tf                Useful values printed after apply
│   ├── resource_group.tf         Platform resource group
│   ├── monitoring.tf             Log Analytics + Application Insights
│   ├── container_registry.tf     Azure Container Registry
│   ├── aks.tf                    AKS cluster + AcrPull role assignment
│   ├── key_vault.tf              Key Vault + RBAC role assignments
│   ├── postgres.tf               PostgreSQL Flexible Server + firewall rules
│   ├── service_bus.tf            Service Bus namespace + queues
│   ├── ingress.tf                NGINX Ingress via Helm
│   ├── cert_manager.tf           cert-manager via Helm
│   └── static_ip.tf              Static public IP for the ingress
│
└── .github/
    └── workflows/
        └── terraform.yml         Plan on PRs, apply on push to main

Everything under infra/ is one Terraform configuration. terraform plan runs on every PR that touches infra/**. terraform apply runs on merges to main.

The CI/CD flow: 

Local development:
I develop from WSL2 (Ubuntu on Windows) with VS Code + Remote-WSL. 
All Terraform commands run through the pipeline; local runs are only for reading state.


