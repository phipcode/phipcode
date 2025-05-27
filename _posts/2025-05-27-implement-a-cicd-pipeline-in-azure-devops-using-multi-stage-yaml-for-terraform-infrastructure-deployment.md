---
layout: post
title: "Implement a CI/CD Pipeline in Azure DevOps Using Multi-Stage YAML for Terraform Infrastructure Deployment"
date: "2025-05-27"
tags: ["azure", "terraform", "iac"]
---

## Introduction

Continuous Integration and Continuous Delivery (CI/CD) are essential practices in modern software development, enabling teams to automate the deployment of applications and infrastructure. In this post, we'll set up a CI/CD pipeline in Azure DevOps using multi-stage YAML to deploy Terraform-managed infrastructure. By the end of this guide, you'll understand how to automate your infrastructure provisioning and management efficiently.

## Prerequisites

Before we begin, ensure you have the following tools and resources in place:

- An Azure account with appropriate permissions to create resources
- An Azure DevOps organization and project
- A basic understanding of Terraform and its configuration files
- Azure DevOps CLI and Terraform installed locally for local testing

## Step-by-Step Guide

### Step 1: Set Up Your Azure DevOps Project

1. **Create a New Azure DevOps Project**:
   - Navigate to your Azure DevOps organization.
   - Click on "New Project" and provide a name (e.g., `terraform-ci-cd`).
   - Choose visibility settings for your project (Public or Private).

2. **Create a Repository**:
   - Inside your newly created project, go to the "Repos" tab and create a new repository.
   - Initialize it with a README file if required.

### Step 2: Add Terraform Configuration Files

Next, create the Terraform configuration files that define your infrastructure.

1. Create a folder named `terraform` in your repository.
2. Create a file named `main.tf` inside the `terraform` directory.

Example `main.tf`:

```terraform
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}
```

### Step 3: Create a Service Connection in Azure DevOps

To allow Azure DevOps to deploy resources in your Azure account:

1. Go to your project settings in Azure DevOps.
2. Navigate to "Service connections".
3. Click on "New service connection" and choose "Azure Resource Manager".
4. Follow the prompts to authenticate and create the service connection with your Azure subscription.

### Step 4: Create the CI/CD Pipeline Using Multi-Stage YAML

In your repository, create a new file named `azure-pipelines.yml`. This file will define your CI/CD pipeline.

```yaml
trigger:
- main

stages:
- stage: Build
  displayName: 'Build Stage'
  jobs:
  - job: TerraformInit
    displayName: 'Terraform Init'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: |
        terraform init
      displayName: 'Initialize Terraform'

  - job: TerraformPlan
    displayName: 'Terraform Plan'
    dependsOn: TerraformInit
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: |
        terraform plan -out=tfplan
      displayName: 'Plan Terraform Changes'

- stage: Deploy
  displayName: 'Deploy Stage'
  dependsOn: Build
  jobs:
  - job: TerraformApply
    displayName: 'Terraform Apply'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: |
        terraform apply -auto-approve tfplan
      displayName: 'Apply Terraform Changes'
```

### Step 5: Commit and Push Your Changes

1. Add your changes to Git.
2. Commit your files with a meaningful message, e.g., "Add Terraform files and pipeline configuration".
3. Push your changes to the Azure DevOps repository.

### Step 6: Run Your Pipeline

1. Navigate to the "Pipelines" tab in Azure DevOps.
2. You should see your pipeline triggered automatically by your latest commit.
3. Monitor the pipeline’s progress, and check for any errors. If successful, you will have deployed the infrastructure defined in your `main.tf` file!

## Code Example

Here's an overview of the Terraform code used in this tutorial:

```terraform
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}
```

This simple Terraform configuration creates a Resource Group in Azure. You can extend this to include more resources as needed for your infrastructure.

## Conclusion

In this blog post, we walked through the process of setting up a CI/CD pipeline in Azure DevOps using multi-stage YAML for Terraform infrastructure deployment. This configuration allows you to automate the steps involved in deploying your infrastructure, ensuring consistency and reliability. With continuous integration and delivery practices, you can focus on building higher-quality applications while Azure DevOps manages your infrastructure deployment. Happy coding!