# Deployment & Azure Integration

> *Last reviewed against [official documentation](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/): April 2026*

## Overview

GitHub Copilot modernization doesn't just upgrade code — it can prepare applications for Azure deployment through containerization, infrastructure as code generation, and CI/CD pipeline setup. This document covers the deployment capabilities and Azure integration points.

## Azure Target Platforms

After modernization, applications can deploy to:

| Platform | Best For | Key Feature |
|----------|----------|-------------|
| **Azure App Service** | Web apps, APIs | Fully managed, auto-scaling, built-in CI/CD |
| **Azure Container Apps** | Microservices, containerized apps | Serverless containers, Dapr integration |
| **Azure Kubernetes Service (AKS)** | Complex orchestration | Full Kubernetes control, enterprise-grade |
| **AKS Automatic** | Simplified Kubernetes | Automated cluster management, reduced ops |

## Containerization Workflow

The modernization agent can generate deployment artifacts as part of the modernization plan:

- **Dockerfiles** for application containerization
- **Infrastructure as Code** (Bicep/ARM templates) for Azure resource provisioning
- **CI/CD pipeline configurations** (GitHub Actions workflows)
- **Deployment manifests** for Kubernetes-based targets

### Example CLI Commands

```bash
# Create a plan for containerization + deployment
modernize plan create "containerize and deploy to azure container apps"

# Deploy to Azure App Service
modernize plan create "deploy to azure app service"

# Set up CI/CD pipeline
modernize plan create "set up CI/CD pipeline for azure"

# Deploy to AKS
modernize plan create "deploy to azure kubernetes service"
```

## Post-Modernization AI Integration

Modernized Azure applications can integrate with:

| Service | Capability |
|---------|-----------|
| **Microsoft Foundry** | Access to 11,000+ AI models |
| **AI Agent Services** | Built-in intelligent application features |
| **Azure Monitor** | Real-time performance insights for AI-powered apps |
| **Content Safety** | Responsible AI implementation at scale |

## Prerequisites for Deployment

Deployment-related modernization tasks typically require:

- **Azure subscription** with appropriate permissions
- **Azure CLI** (`az`) installed and authenticated
- **Docker** installed (for containerization tasks)
- Target Azure resources provisioned or permissions to create them

> **Note:** An Azure account is required only for deploying resources to Azure. Code transformation, assessment, and planning do not require an Azure subscription.

## Further Reading

| Resource | URL |
|----------|-----|
| Azure App Service | [learn.microsoft.com/...app-service](https://learn.microsoft.com/en-us/azure/app-service/) |
| Azure Container Apps | [learn.microsoft.com/...container-apps](https://learn.microsoft.com/en-us/azure/container-apps/) |
| Azure Kubernetes Service | [learn.microsoft.com/...aks](https://learn.microsoft.com/en-us/azure/aks/) |
| GitHub Copilot modernization overview | [learn.microsoft.com/...overview](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/overview) |
