---
layout: post
title: "How to create a github workflow for terraform"
date: "2025-07-24 11:48:26"
tags: ["azure", "terraform", "iac", "tutorial"]
author: "AI Writer"
description: "A step-by-step guide about How to create a github workflow for terraform using terraform."
---

# How to create a GitHub Workflow for Terraform

*Published on 2025-07-24 by AI Writer*

---

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Architecture Overview](#architecture-overview)
4. [Step-by-Step Guide](#step-by-step-guide)
5. [Code Example](#code-example)
6. [Cleanup](#cleanup)
7. [Conclusion](#conclusion)
8. [Further Reading](#further-reading)

---

## Introduction

In today's cloud-centric environment, infrastructure as code (IaC) has become essential for automating the provisioning and management of infrastructure. Terraform is one of the most popular tools for IaC, and integrating it with GitHub workflows allows teams to automate their infrastructure deployments directly from their repositories. In this tutorial, we will walk through the steps to create a GitHub Actions workflow for Terraform, enabling automatic execution of your Terraform scripts controlled by events in your GitHub repository.

---

## Prerequisites

Before you begin, ensure you have the following:

- A GitHub account
- A repository to work within
- Basic knowledge of Terraform and GitHub Actions
- Terraform installed locally for testing (optional)

---

## Architecture Overview

In our architecture, we'll leverage GitHub Actions to run Terraform commands. The architecture can be summarized as follows:

1. **GitHub Repository**: Contains the Terraform scripts and the CI/CD workflow configuration.
2. **GitHub Actions**: Automates the execution of Terraform commands based on triggers, such as pushes to the repository.
3. **Terraform Execution**: Handles the creation, modification, or destruction of infrastructure based on the defined configuration.

---

## Step-by-Step Guide

### Step 1: Create a GitHub Repository

1. Log in to your GitHub account.
2. Create a new repository and clone it to your local machine.

### Step 2: Add Terraform Files

Create your Terraform configuration files in the repository. For example, you might have a file called `main.tf` for your infrastructure resources.

### Step 3: Create Workflow Configuration

Create a new directory for GitHub workflows:

```bash
mkdir -p .github/workflows
```

Inside this directory, create a new file named `terraform.yml`.

### Step 4: Define the Workflow

Edit `terraform.yml` and define your workflow. Below is an example workflow configuration:

```yaml
name: "Terraform CI"

on:
  pull_request:
    branches:
      - main
      
jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 1.0.0
        
    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan

    - name: Terraform Apply
      run: terraform apply -auto-approve
```

### Step 5: Commit and Push the Changes

Commit your changes and push them to the GitHub repository.

```bash
git add .
git commit -m "Add Terraform workflow"
git push origin main
```

### Step 6: Trigger the Workflow

Create a pull request or push changes to the specified branch to trigger the GitHub Actions workflow. You can view the logs and status of the workflow directly in the "Actions" tab of your repository.

---

## Code Example

Here’s an example configuration in `main.tf` for a simple AWS EC2 instance:

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}
```

This basic setup will provision an EC2 instance using the specified AMI.

---

## Cleanup

To avoid incurring costs, make sure to destroy the resources created by Terraform:

1. Run the following command in your local Terraform setup:

```bash
terraform destroy
```

Alternatively, you can add a separate workflow for resource destruction.

---

## Conclusion

In this tutorial, we've walked through the steps to set up a GitHub Actions workflow for Terraform. By automating your infrastructure deployments, you enhance consistency and reduce the chance of human errors. As you advance, consider implementing additional features such as environment variable configurations, state management, and integration with cloud services.

---

## Further Reading

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Infrastructure as Code: Managing Servers in the Cloud](https://www.oreilly.com/library/view/infrastructure-as-code/9781491920981/)

With this knowledge, you're now equipped to automate your infrastructure deployments using Terraform and GitHub Actions!