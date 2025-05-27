---
layout: post
title: "Running azure devops agent using azure container instance"
date: "2025-05-27"
tags: ["azure", "terraform", "iac"]
---

## Introduction

Azure DevOps is a platform that provides development and collaboration tools to create and ship software. One of the key components of Azure DevOps is the build and release pipeline, which uses agents to execute jobs. In this post, we will explore how to run an Azure DevOps agent inside an Azure Container Instance (ACI) leveraging Infrastructure as Code (IaC) with Terraform. This approach allows for dynamic scaling and eliminates the overhead of managing Virtual Machines.

## Prerequisites

Before we dive into the setup process, ensure you have the following prerequisites in place:

1. **Azure Subscription**: You need an active Azure subscription.
2. **Terraform**: Install Terraform on your local machine. Follow the [official documentation](https://www.terraform.io/downloads.html) for installation instructions.
3. **Azure CLI**: Ensure you have the Azure CLI installed. You can download it from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
4. **Azure DevOps Organization**: Create an Azure DevOps organization if you haven't done so already.

## Step-by-Step Guide

### Step 1: Create a Service Principal

Create a Service Principal to allow Terraform to interact with Azure resources. Replace `your-app-name` and adjust the `--role` and `--scopes` according to your requirements.

```bash
az ad sp create-for-rbac --name your-app-name --role Contributor --scopes /subscriptions/{subscription-id}
```

### Step 2: Create a Terraform Configuration

Now, let's write the Terraform configuration to set up an Azure Container Instance that runs an Azure DevOps agent. Create a file named `main.tf` and add the following code.

### Step 3: Initialize Terraform

Navigate to the directory where your `main.tf` file is located and run the following command to initialize Terraform:

```bash
terraform init
```

### Step 4: Plan the Terraform Deployment

Run the Terraform plan command to check what resources will be created:

```bash
terraform plan
```

### Step 5: Apply the Terraform Deployment

Deploy the resources by executing the following command:

```bash
terraform apply
```

Confirm with `yes` when prompted.

## Code Example

```terraform
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "devops-agent-rg"
  location = "East US"
}

resource "azurerm_container_group" "devops_agent" {
  name                = "devops-agent-container"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "agent"
    image  = "mcr.microsoft.com/azure-pipelines/vsts-agent:latest"
    cpu    = "1"
    memory = "1.5"
    
    # Set the necessary environment variables for Azure DevOps agent configuration
    environment_variables = {
      "AGENT_URL"          = "https://dev.azure.com/your organization"
      "AGENT_TOKEN"        = "your_personal_access_token"
      "AGENT_NAME"         = "my-agent"
    }

    ports {
      port     = 80
      protocol = "TCP"
    }

    commands = [
      "/bin/bash",
      "-c",
      "run.sh"
    ]
  }

  ip_address_type = "public"
  dns_name_label  = "devopsagent"
}
```

### Step 6: Manage the Container Instance

Once the Azure DevOps agent is up and running, you can monitor the container instance using the Azure Portal or Azure CLI. To view logs or get the current status, you can use:

```bash
az container show --resource-group devops-agent-rg --name devops-agent-container --query "instanceView.state" -o table
```

## Conclusion

Running Azure DevOps agents within Azure Container Instances offers numerous benefits, including lower overhead and the ability to scale resources dynamically. By using Terraform for IaC, we can manage and deploy our infrastructure in a repeatable and consistent manner. This setup can significantly enhance the flexibility and efficiency of your CI/CD processes.

Now that you have your Azure DevOps agent running in ACI, you can leverage it for automated builds and releases as part of your DevOps pipeline.
