# DevOps Terraform LAMP Server

End-to-End Full Stack Application Deployment using **Terraform** and **Docker Compose**.

This project simulates a **real-world DevOps scenario** where frontend and backend code is provided by developers, and the **DevOps engineer is responsible for provisioning infrastructure and deploying the complete application stack**.

---

## 🧩 Project Overview

This repository deploys a **containerized full-stack application** on an **AWS EC2 instance** using **Terraform** for infrastructure provisioning and **Docker Compose** for application orchestration.

The stack includes:

* **React.js** – Frontend
* **Spring Boot** – Backend
* **MySQL** – Database

---

## 🏗️ Project Architecture

```
                ┌────────────────────────────┐
                │        User Browser         │
                └──────────────┬─────────────┘
                               │
                               │ HTTP :3000
                               ▼
                ┌────────────────────────────┐
                │        AWS EC2 Instance     │
                │                            │
                │  ┌──────────────────────┐ │
                │  │   React.js Container  │ │
                │  │      (Frontend)       │ │
                │  └──────────┬───────────┘ │
                │             │ REST API     │
                │             ▼               │
                │  ┌──────────────────────┐ │
                │  │ Spring Boot Container │ │
                │  │      (Backend)        │ │
                │  └──────────┬───────────┘ │
                │             │ JDBC          │
                │             ▼               │
                │  ┌──────────────────────┐ │
                │  │   MySQL Container     │ │
                │  │      (Database)       │ │
                │  └──────────────────────┘ │
                │                            │
                │   Docker Compose Runtime   │
                └────────────────────────────┘

Infrastructure Provisioned using Terraform
```

---

## 📁 Repository Structure

```
DevOps-Terraform-LAMP-Server/
├── code/                   # Frontend (React) and Backend (Spring Boot) source code
├── docker-compose.yaml     # Multi-container setup (React, Spring Boot, MySQL)
├── main.tf                 # Terraform infrastructure definition
└── README.md               # Project documentation
```

---

## 🚀 Getting Started (Copy-Paste Friendly)

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/lavatech321/DevOps-Terraform-LAMP-Server.git
```

```bash
cd DevOps-Terraform-LAMP-Server
```

---

### 2️⃣ Verify Project Files

```bash
ls
```

Expected output:

```
code
docker-compose.yaml
main.tf
```

---

### 3️⃣ (Optional) Review Terraform Configuration

```bash
vi main.tf
```

---

### 4️⃣ Initialize Terraform

```bash
terraform init
```

---

### 5️⃣ Deploy Infrastructure and Application

```bash
terraform apply --auto-approve
```

---

## ✅ Sample Terraform Output

```
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

App-Live =
Reactjs and Spring boot Live: http://3.16.79.49:3000

Docker-compose =
LAMP server: docker compose ps -a

MYsql-Live =
MySQL Credentials: mysql -uappuser -papppass appdb

public_ip =
Public IP address: ec2-user@3.16.79.49

sshkey =
SSH Key location: ~/.ssh/id_rsa
```

---

## 🌐 Access the Application

* **Frontend & Backend Application**

  ```
  http://<PUBLIC_IP>:3000
  ```

* **MySQL Database Access**

  ```bash
  mysql -uappuser -papppass appdb
  ```

* **Check Running Containers**

  ```bash
  docker compose ps -a
  ```

---

## 🎯 Learning Objectives

By completing this project, learners will gain hands-on experience with:

* Terraform-based infrastructure provisioning
* AWS EC2 resource management
* Docker and Docker Compose
* Deploying React + Spring Boot + MySQL
* End-to-end DevOps workflows

---

## 👥 Who Should Use This Project

* DevOps beginners
* Terraform learners
* Docker & containerization learners
* Full-stack developers learning DevOps

---

## ⚠️ Important Notes

* AWS credentials must be configured before running Terraform
* This project is intended for **learning and demonstration purposes only**
* Avoid using hardcoded credentials in production environments

---

## 🧹 Cleanup (Optional)

To destroy all created resources:

```bash
terraform destroy --auto-approve
```

---

## ⭐ Final Summary

This repository provides a **complete hands-on DevOps project** demonstrating how infrastructure and applications are deployed together using Terraform and Docker Compose.

It closely mirrors real-world scenarios where DevOps engineers bridge the gap between development and production.

Happy Learning 🚀
