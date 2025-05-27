---
layout: post
title: "Create a Virtual Machine in Terraform"
date: "2025-05-27"
tags: ["azure", "bicep", "iac"]
---

## Introduction

In today's cloud-centric world, Infrastructure as Code (IaC) tools like Terraform have revolutionized how we deploy and manage infrastructure. This blog post will guide you through creating a virtual machine (VM) in Azure using Terraform. Whether you're a beginner or someone looking to brush up on your IaC skills, this tutorial will provide step-by-step instructions and relevant code examples.

## Prerequisites

Before you get started, ensure that you have the following prerequisites:

1. **Azure Account**: Create a free Azure account if you do not have one.
2. **Terraform Installed**: Download and install Terraform from the [Terraform website](https://www.terraform.io/downloads.html).
3. **Azure CLI**: Install the Azure CLI to manage Azure resources via the command line.
4. **A code editor**: Use any code editor of your choice, such as Visual Studio Code or Atom.

## Step-by-Step Guide

### Step 1: Set Up Your Azure Provider

First, you need to configure the Azure provider in your Terraform script. This will allow Terraform to interact with the Azure platform.

Create a new directory for your project and create a file named `main.tf`.

```hcl
provider "azurerm" {
  features {}
}
```

### Step 2: Define Your Resource Group

Next, create a resource group where your VM will reside. Add the following configuration to your `main.tf` file:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}
```

### Step 3: Create a Virtual Network and Subnet

A virtual machine needs to be part of a network. Thus, you will create a virtual network and a subnet:

```hcl
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

### Step 4: Create a Public IP Address

You will need a public IP address for the VM to be accessible over the internet:

```hcl
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}
```

### Step 5: Create a Network Interface

Next, define a network interface to connect the VM to the subnet and public IP:

```hcl
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example-ip-config"
    subnet_id                    = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.example.id
  }
}
```

### Step 6: Create the Virtual Machine

Finally, create the virtual machine by adding the following code:

```hcl
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!" // Ensure to set a strong password!

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

## Code Example

Here is the complete `main.tf` file:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example-ip-config"
    subnet_id                    = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!" // Ensure to set a strong password!

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

## Conclusion

Congratulations! You have successfully created a virtual machine in Azure using Terraform. Infrastructure as Code helps streamline cloud resource management and enables repeatable and predictable infrastructure deployment. Feel free to customize the configurations in the code sample provided to meet your specific requirements. Happy coding!
