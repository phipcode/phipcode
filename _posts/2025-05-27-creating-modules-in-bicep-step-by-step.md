---
layout: post
title: "Creating modules in bicep step by step"
date: "2025-05-27"
tags: ["azure", "terraform", "iac", "tutorial"]
author: "AI Writer"
description: "A step-by-step guide about Creating modules in bicep step by step."
---

# Creating modules in bicep step by step

*Published on 2025-05-27 by AI Writer*

---

## Table of Contents

- [Creating modules in bicep step by step](#creating-modules-in-bicep-step-by-step)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Prerequisites](#prerequisites)
  - [Architecture Overview](#architecture-overview)
  - [Step-by-Step Guide](#step-by-step-guide)
    - [Step 1: Create the Module Files](#step-1-create-the-module-files)
    - [Step 2: Define Your Network Module](#step-2-define-your-network-module)
    - [Step 3: Define Your Database Module](#step-3-define-your-database-module)
    - [Step 4: Create the Main Bicep File](#step-4-create-the-main-bicep-file)
    - [Step 5: Deploy the Main Bicep File](#step-5-deploy-the-main-bicep-file)
  - [Code Example](#code-example)
  - [Cleanup](#cleanup)
  - [Conclusion](#conclusion)
  - [Further Reading](#further-reading)

---

## Introduction

Bicep is a domain-specific language (DSL) that simplifies the process of deploying Azure resources. One of its powerful features is the ability to create modules, which allows developers to encapsulate and reuse resource definitions. Modules help maintain cleaner code, improve readability, and streamline the collaborative development process. This guide will walk you through creating modules in Bicep step by step.

---

## Prerequisites

Before you begin, ensure you have the following:

- An Azure account with required permissions.
- Bicep CLI installed; you can follow [this guide](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) for installation instructions.
- Basic knowledge of Azure resources and Bicep syntax.
- A code editor such as Visual Studio Code with the Bicep extension installed.

---

## Architecture Overview

Creating modular architectures in Bicep allows you to decouple resource deployments and improve maintainability. The high-level architecture typically consists of:

- **Main Bicep file**: This file orchestrates the deployment.
- **Module files**: These files define the resources that can be reused across deployments (e.g., networking, databases).

Here's a basic representation of the architecture:

```
Main.bicep
├── Network.bicep
└── Database.bicep
```

---

## Step-by-Step Guide

### Step 1: Create the Module Files

1. **Create a new directory** for your Bicep project if you haven't already done so.
2. Inside this directory, create the files for each module you need, e.g., `Network.bicep` and `Database.bicep`.

### Step 2: Define Your Network Module

In `Network.bicep`, define your network resources. Here’s an example:

```bicep
param vnetName string
param addressSpace string

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [ addressSpace ]
    }
  }
}
```

### Step 3: Define Your Database Module

Create `Database.bicep` with the database resource definition:

```bicep
param sqlServerName string
param location string

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'YourPassword123!'
  }
}
```

### Step 4: Create the Main Bicep File

Create a `Main.bicep` file to call these modules:

```bicep
targetScope = 'resourceGroup'

module network 'Network.bicep' = {
  name: 'networkModule'
  params: {
    vnetName: 'myVNet'
    addressSpace: '10.0.0.0/16'
  }
}

module database 'Database.bicep' = {
  name: 'databaseModule'
  params: {
    sqlServerName: 'mySqlServer'
    location: resourceGroup().location
  }
}
```

### Step 5: Deploy the Main Bicep File

Use the following Azure CLI command to deploy your main Bicep file:

```bash
az deployment group create --resource-group <YourResourceGroupName> --template-file Main.bicep
```

Replace `<YourResourceGroupName>` with the name of your Azure resource group.

---

## Code Example

Here is a complete code example that includes all the files mentioned:

```bicep
// Main.bicep
targetScope = 'resourceGroup'

module network 'Network.bicep' = {
  name: 'networkModule'
  params: {
    vnetName: 'myVNet'
    addressSpace: '10.0.0.0/16'
  }
}

module database 'Database.bicep' = {
  name: 'databaseModule'
  params: {
    sqlServerName: 'mySqlServer'
    location: resourceGroup().location
  }
}

// Network.bicep
param vnetName string
param addressSpace string

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [ addressSpace ]
    }
  }
}

// Database.bicep
param sqlServerName string
param location string

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'YourPassword123!'
  }
}
```

---

## Cleanup

To avoid incurring costs for resources you have created, delete the resource group:

```bash
az group delete --name <YourResourceGroupName> --yes --no-wait
```

---

## Conclusion

Creating modules in Bicep enhances code organization and reusability, which is vital for maintaining large-scale infrastructure as code. By encapsulating resources into modules, you can manage your deployments more effectively and streamline collaboration among team members.

---

## Further Reading

- [Bicep Documentation](https://docs.microsoft.com/en-us/azure/resource-manager/bicep/)
- [Understanding Bicep Modules](https://docs.microsoft.com/en-us/azure/resource-manager/bicep/modules)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
```
