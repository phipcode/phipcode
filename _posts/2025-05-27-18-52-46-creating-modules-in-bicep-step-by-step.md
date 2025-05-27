---
layout: post
title: "Creating modules in bicep step by step"
date: "2025-05-27 18:52:12"
tags: ["azure", "terraform", "iac", "tutorial"]
author: "AI Writer"
description: "A step-by-step guide about Creating modules in bicep step by step using terraform."
---

# Creating modules in bicep step by step

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

In modern cloud infrastructure management, using declarative configuration languages such as Bicep allows for easier management and deployment of Azure resources. A modular approach enables better organization, reusability, and maintainability of your infrastructure as code (IaC). This guide will walk you through creating modules using Bicep step by step, empowering you to build scalable and maintainable infrastructure.

---

## Prerequisites

Before you begin, ensure you have the following:

- An active Azure subscription
- Azure CLI installed and configured
- Bicep CLI installed (or Azure CLI with Bicep support)
- Basic understanding of Bicep syntax and Azure Resources

---

## Architecture Overview

When using Bicep for infrastructure deployment, the structure typically consists of several modules that define specific resources or functionalities. This modular architecture allows you to separate concerns and promote reuse throughout your projects.

Imagine a system where you define:

- A networking module for setting up virtual networks and subnets.
- A compute module for creating virtual machines.
- A storage module for provisioning storage accounts.

By modularizing your infrastructure, any change or addition can be handled independently.

---

## Step-by-Step Guide

### Step 1: Create Your Main Bicep File

Start by creating a main `main.bicep` file that acts as the entry point to your Bicep files.

```bicep
// main.bicep
targetScope = 'resourceGroup'

// Importing modules
module networkModule './network.bicep' = {
  name: 'networkDeployment'
  params: {
    location: resourceGroup().location
  }
}

module computeModule './compute.bicep' = {
  name: 'computeDeployment'
  params: {
    location: resourceGroup().location
    vnetId: networkModule.outputs.vnetId
  }
}
```

### Step 2: Create Your Modules

Now, create individual Bicep files for each module.

#### Network Module (`network.bicep`)

```bicep
// network.bicep
param location string

var vnetName = 'myVNet'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

output vnetId string = vnet.id
```

#### Compute Module (`compute.bicep`)

```bicep
// compute.bicep
param location string
param vnetId string

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'myVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'myVM'
      adminUsername: 'azureuser'
      adminPassword: 'ComplexPassword123!'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vnetId
        }
      ]
    }
  }
}
```

### Step 3: Deploy Your Bicep Files

To deploy your Bicep files, run the command below in your terminal:

```bash
az deployment group create --resource-group <YourResourceGroupName> --template-file main.bicep
```

### Step 4: Verify the Deployment

After running the deployment, you can check the Azure portal or use:

```bash
az vm show --resource-group <YourResourceGroupName> --name myVM
```

---

## Code Example

The complete code structure would look like this in your project:

```
/my-bicep-project
│
├── main.bicep
├── network.bicep
└── compute.bicep
```

Each file serves its purpose, ensuring that you adhere to a clear and maintainable structure.

---

## Cleanup

Once you are done testing and experimenting, remember to clean up your Azure resources to avoid unnecessary charges. You can do this with the following command:

```bash
az group delete --name <YourResourceGroupName> --yes --no-wait
```

---

## Conclusion

Creating modules in Bicep is a powerful way to manage Azure resources by dividing your infrastructure into manageable components. Following this guide, you should now be able to create, deploy, and maintain your Bicep modules efficiently.

---

## Further Reading

- [Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Learning Bicep](https://github.com/Azure/bicep/blob/main/docs/tutorials/quickstart.md)
- [Understanding Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/understanding-arm)

---