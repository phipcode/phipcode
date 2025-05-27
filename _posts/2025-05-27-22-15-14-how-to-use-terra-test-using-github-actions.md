---
{% raw %}---
title: "How to use Terra test using GitHub actions"
date: "2025-05-27 22:14:47"
tags: ["azure", "Hcl", "iac", "tutorial"]
author: "AI Writer"
description: "A step-by-step guide about How to use Terra test using GitHub actions using Hcl."
---

# How to use Terra test using GitHub actions

*Published on 2025-05-27 by AI Writer*

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

In the world of Infrastructure as Code (IaC), ensuring your configurations work as intended before deploying them can save you from potential issues down the line. One popular tool for testing Terraform configurations is [TerraTest](https://github.com/gruntwork-io/terratest). This guide will walk you through using TerraTest in combination with GitHub Actions to automate testing of your Terraform code.

---

## Prerequisites

Before you begin, ensure you have the following set up:

- A GitHub account.
- A GitHub repository with Terraform code (HCL).
- Basic knowledge of Terraform and its configuration files.
- Understanding of GitHub Actions and CI/CD concepts.
- Familiarity with testing frameworks in Go (as TerraTest uses Go).

---

## Architecture Overview

The workflow integrates GitHub Actions with TerraTest, allowing you to automatically test your Terraform configurations every time changes are committed to your repository. Below is a high-level overview of how the architecture looks:

1. Code is committed to the GitHub repository.
2. A GitHub Action is triggered.
3. The action runs TerraTest to validate the Terraform code.
4. Any failures in the tests halt the process and notify the developer.

---

## Step-by-Step Guide

### Step 1: Install TerraTest

You can include TerraTest in your Go environment. If you do not have Go installed, you can follow the [official guide](https://golang.org/doc/install) to get Go set up.

### Step 2: Create a Go Module

In your GitHub repository, create a new directory for tests and initialize a Go module:

```bash
mkdir tests
cd tests
go mod init tests
```

### Step 3: Write your TerraTest

Create a Go file for your tests (e.g., `main_test.go`):

```go
package tests

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraform(t *testing.T) {
    terraformOptions := &terraform.Options{
        // The path to the Terraform code that will be tested.
        TerraformDir: "../path_to_your_terraform_code",

        // Variables to pass to our Terraform code using -var options
        Vars: map[string]interface{}{
            "example_variable": "value",
        },
    }

    // Clean up resources with `terraform destroy` at the end of the test.
    defer terraform.Destroy(t, terraformOptions)

    // This will run `terraform init` and `terraform apply`. Fails the test if there are any errors.
    terraform.InitAndApply(t, terraformOptions)
}
```

### Step 4: Create GitHub Actions Workflow

Create a GitHub Actions workflow in `.github/workflows/terratest.yml`:

```yaml
name: TerraTest Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Go
        uses: actions/setup-go@v2
        with:
          go-version: '1.16'  # Specify the Go version you want to use

      - name: Install Go dependencies
        run: go mod tidy

      - name: Run TerraTest
        run: go test -v tests/
```

### Step 5: Commit and Push Changes

Add, commit, and push your changes to the repository:

```bash
git add .
git commit -m "Set up TerraTest with GitHub Actions"
git push origin main
```

### Step 6: Monitor GitHub Actions

After pushing your code, navigate to the "Actions" tab in your GitHub repository. You should see the workflow triggered, and it will either pass or fail based on the results of the TerraTest execution.

---

## Code Example

Here’s a complete code example covering the basic setup:

**Terraform Directory Structure:**

```
your-repo/
├── .github/
│   └── workflows/
│       └── terratest.yml
├── main.tf
└── tests/
    └── main_test.go
```

**main_test.go**

```go
package tests

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraform(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../", // Adjust the path according to your directory structure

        Vars: map[string]interface{}{
            "variable_key": "value",
        },
    }

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)
}
```

---

## Cleanup

To clean up resources created during testing, ensure that your `defer terraform.Destroy(t, terraformOptions)` line is set before executing any terraform commands. This will help in removing the resources automatically once the tests have completed.

---

## Conclusion

Automating infrastructure tests using TerraTest and GitHub Actions provides a robust solution for maintaining code quality and verifying the integrity of your Terraform configurations. This setup not only helps catch errors early but also enhances collaboration across teams.

---

## Further Reading

- [TerraTest Documentation](https://gruntwork.io/terratest/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Infrastructure as Code Best Practices](https://www.terraform.io/docs/language/code.html) 

---