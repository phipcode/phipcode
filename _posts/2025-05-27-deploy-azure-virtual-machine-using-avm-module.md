---
layout: post
title: "Deploy Azure Virtual Machine using AVM Module"
date: "2025-05-27"
tags: ["azure", "bicep", "iac"]
---

## Introduction

In this blog post, we will explore how to deploy an Azure Virtual Machine (VM) using the Azure Virtual Machine (AVM) module with Bicep. The AVM module simplifies the deployment process by encapsulating complex configurations, enabling you to deploy VMs quickly and efficiently. 

## Prerequisites

Before you begin, ensure you have the following:

- An active Azure subscription.
- The Azure CLI installed and configured.
- The latest version of Bicep installed on your machine.
- Familiarity with Azure Resource Manager (ARM) templates and basic knowledge of Bicep syntax.

## Step-by-Step Guide

### Step 1: Set Up Your Environment

First, open your preferred code editor and create a new Bicep file (e.g., `main.bicep`). Then, you will define some parameters for your VM. 

### Step 2: Define Parameters

Add the following parameters to the top of your `main.bicep` file. You'll use these to customize the deployment of your VM:

```bicep
param vmName string = 'myVM'
param adminUsername string
@secure()
param adminPassword string
param location string = resourceGroup().location
```

### Step 3: Import the AVM Module

To deploy the VM, we'll import the Azure Virtual Machine module. You can find the module in the Azure Bicep GitHub repository or Azure Quickstart templates. 

```bicep
module avm 'br/msft/avm@1.0.0' = {
  name: 'myVMDeployment'
  params: {
    vmName: vmName
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
  }
}
```

### Step 4: Configure VM Details

Next, you'll want to configure your VM details such as size, OS type, and image. Here is an example of additional parameters you can specify:

```bicep
@allowed(['Standard_DS1_v2', 'Standard_DS2_v2'])
param vmSize string = 'Standard_DS1_v2'

param osType string = 'Linux'
param imagePublisher string = 'Canonical'
param imageOffer string = 'UbuntuServer'
param imageSku string = '18.04-LTS'
```

Modify the module parameters for these VM details:

```bicep
module avm 'br/msft/avm@1.0.0' = {
  name: 'myVMDeployment'
  params: {
    vmName: vmName
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
    vmSize: vmSize
    osType: osType
    imagePublisher: imagePublisher
    imageOffer: imageOffer
    imageSku: imageSku
  }
}
```

### Step 5: Deploy Your Bicep File

To deploy the Bicep file you created, use the Azure CLI:

```bash
az deployment group create --resource-group yourResourceGroup --template-file main.bicep --parameters adminUsername='your_username' adminPassword='your_password'
```

Replace `yourResourceGroup`, `your_username`, and `your_password` with your specific details.

## Code Example

Here’s the complete code for the Bicep file we discussed:

```bicep
param vmName string = 'myVM'
param adminUsername string
@secure()
param adminPassword string
param location string = resourceGroup().location

@allowed(['Standard_DS1_v2', 'Standard_DS2_v2'])
param vmSize string = 'Standard_DS1_v2'

param osType string = 'Linux'
param imagePublisher string = 'Canonical'
param imageOffer string = 'UbuntuServer'
param imageSku string = '18.04-LTS'

module avm 'br/msft/avm@1.0.0' = {
  name: 'myVMDeployment'
  params: {
    vmName: vmName
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
    vmSize: vmSize
    osType: osType
    imagePublisher: imagePublisher
    imageOffer: imageOffer
    imageSku: imageSku
  }
}
```

## Troubleshooting

If you encounter issues during deployment, check the following:

1. Ensure that the Azure CLI is updated to the latest version.
2. Verify that you have the necessary permissions to create resources in the Azure subscription.
3. Check the Azure Resource Manager (ARM) deployment output for detailed error messages.

## Summary

In this guide, we've gone through the steps to deploy an Azure Virtual Machine using the AVM Bicep module. By leveraging the AVM module, you can simplify your infrastructure deployments and maintain your configuration as code.
```