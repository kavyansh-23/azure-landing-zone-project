# Azure Landing Zone & Multi-Cloud GitOps Architecture

**Author:** Kavyansh Gandhi | **Contact:** kavyagandhi5359@gmail.com

## Project Overview
This project provisions a secure, multi-cloud foundation using Infrastructure as Code (Terraform), Configuration as Code (Ansible), and continuous deployment (GitOps). Designed with enterprise constraints in mind, the architecture includes an Azure Hub-and-Spoke network, RBAC assignments, automated policy enforcement, and a GitOps-managed Kubernetes cluster running containerized microservices.

## Architecture Diagram
mermaid
graph TD
subgraph GitHub [GitHub Repository]
A[Terraform IaC]
B[Ansible Playbooks]
C[Kubernetes Manifests]
D[GitHub Actions CI]
end

subgraph Azure [Azure Landing Zone]
        MG[Platform Management Group]
        Pol[Azure Policies: Allowed Regions, Deny Public IPs]
        MG --> Pol
        
        subgraph VNet [Hub-and-Spoke Network]
            Hub[Hub VNet]
            Spoke[Spoke VNet]
            Hub --- Spoke
        end
        
        VM[Linux VM]
        AKS[AKS Cluster]
        
        Hub --> VM
        Spoke --> AKS
    end

    subgraph AWS [AWS Add-on]
        VPC[AWS Minimal VPC]
    end

    subgraph Cluster [Kubernetes]
        Argo[Argo CD]
        MS1[Microservice 1: Nginx]
        MS2[Microservice 2: Apache]
        Argo --> MS1
        Argo --> MS2
    end

    D -. Validates & Plans .-> A
    D -. Lints .-> B
    A --> Azure
    A --> AWS
    B --> VM
    C <-- Pulls Manifests --- Argo

    ## Design Choices & Justifications

1. **Landing Zone in Terraform:** I utilized a Management Group hierarchy to apply Azure Policies at the top level, ensuring that all underlying subscriptions and resource groups automatically inherit security baselines (like denying public IPs). Remote state is structured to sit in a secure storage account to enable team collaboration and state locking.
2. **Configuration as Code with Ansible:** I structured the Ansible codebase using modular roles rather than a single monolithic playbook. This ensures that individual components (SSH hardening, Docker installation, Prometheus Node Exporter) can be reused or updated independently.
3. **Containerized Workloads in AKS:** Deploying the microservices into an isolated spoke virtual network limits the blast radius of potential security incidents while allowing secure peering back to the hub network for monitoring and administration.
4. **GitOps via Argo CD:** Instead of pushing deployments directly from GitHub Actions (`kubectl apply`), I implemented Argo CD. This pull-based GitOps model guarantees that the cluster state strictly matches the Git repository, automatically preventing and self-healing any manual configuration drift.
5. **Multi-Cloud Scalability:** I integrated a minimal AWS provider deployment within the same Terraform pipeline to demonstrate that the CI/CD workflow is cloud-agnostic and ready to support hybrid environments.