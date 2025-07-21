---
layout: post
title: "Install n8n with Docker Compose: Step-by-Step Guide"
date: "2025-07-22 01:53:12"
tags: ["azure", "yaml", "iac", "tutorial"]
author: "AI Writer"
description: "A step-by-step guide about Install n8n with Docker Compose: Step-by-Step Guide using yaml."
---

# Install n8n with Docker Compose: Step-by-Step Guide

*Published on 2025-07-22 by AI Writer*

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

n8n is a powerful open-source workflow automation tool that allows you to connect various services and automate tasks without requiring extensive programming knowledge. It provides a visual interface for building integrations and automating workflows. Using Docker Compose simplifies the deployment process, making it easy to manage multi-container applications like n8n.

---

## Prerequisites

Before you begin, ensure you have the following:

- A machine with Docker and Docker Compose installed.
- Basic understanding of command-line operations.
- An account for any services you intend to integrate with n8n, such as databases or APIs.

---

## Architecture Overview

n8n can be deployed using multiple components in a Docker environment. The architecture usually consists of:

- **n8n web application**: The main application that users interact with.
- **PostgreSQL database**: Used to store workflow data, credential information, and execution history.

The services communicate over a Docker network, allowing for easy and isolated service management.

---

## Step-by-Step Guide

### Step 1: Create a Project Directory

Start by creating a directory for your n8n project.

```bash
mkdir n8n-docker
cd n8n-docker
```

### Step 2: Create the Docker Compose File

Create a file named `docker-compose.yml` in the project directory.

```bash
touch docker-compose.yml
```

### Step 3: Edit the Docker Compose File

Open `docker-compose.yml` in your favorite text editor and add the following contents:

```yaml
version: '3.1'

services:
  n8n:
    image: n8n
    environment:
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=db
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=n8n_password
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=your_username
      - N8N_BASIC_AUTH_PASSWORD=your_password
    ports:
      - "5678:5678"
    depends_on:
      - db
    networks:
      - n8n-network

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=n8n
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=n8n_password
    networks:
      - n8n-network

networks:
  n8n-network:
    driver: bridge
```

### Step 4: Start the Services

Once the configuration is complete, run the following command to start the n8n and PostgreSQL services:

```bash
docker-compose up -d
```

### Step 5: Access n8n Web Interface

Open your web browser and go to `http://localhost:5678` to access the n8n interface. 

### Step 6: Set Up the First Workflow

Log in using the credentials defined in your `docker-compose.yml` file, and start building your automation workflows.

---

## Code Example

Here’s a complete example of the `docker-compose.yml` file:

```yaml
version: '3.1'

services:
  n8n:
    image: n8n
    environment:
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=db
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=n8n_password
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=your_username
      - N8N_BASIC_AUTH_PASSWORD=your_password
    ports:
      - "5678:5678"
    depends_on:
      - db
    networks:
      - n8n-network

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=n8n
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=n8n_password
    networks:
      - n8n-network

networks:
  n8n-network:
    driver: bridge
```

---

## Cleanup

To stop and remove the services, run:

```bash
docker-compose down
```

This command will stop and remove all containers defined in the `docker-compose.yml` file, without removing the volumes.

---

## Conclusion

You have successfully installed n8n using Docker Compose! This process allows you to easily manage and scale your automation workflows as needed. n8n provides a wide range of integrations—visit their documentation to explore further and make the most of your workflows.

---

## Further Reading

- [n8n Documentation](https://docs.n8n.io/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/) 

Feel free to follow the links for more detailed information and best practices on using n8n and Docker!