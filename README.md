# Azure Landing Zone & Multi-Cloud GitOps Architecture

**Author:** Kavyansh Gandhi | **Contact:** kavyagandhi5359@gmail.com

## Project Overview
This project provisions a secure, multi-cloud foundation using Infrastructure as Code (Terraform), Configuration as Code (Ansible), and continuous deployment (GitOps). Designed with enterprise constraints in mind, the architecture includes an Azure Hub-and-Spoke network, RBAC assignments, automated policy enforcement, and a GitOps-managed Kubernetes cluster running containerized microservices.

## Architecture Diagram

```mermaid
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
