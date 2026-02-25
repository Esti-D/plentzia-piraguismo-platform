# plentzia-piraguismo-platform

## 🧭 Context

The Plentzia Canoe Club currently lacks a functional digital platform.  
Its online presence is limited to an outdated blog, and administrative processes (registrations, communication, content publishing) are managed manually.

Due to the natural rotation of responsibilities within the association, the solution must be:

- Simple to use  
- Sustainable over time  
- Independent from continuous technical maintenance  
- Cost-efficient  

---

## 🎯 Project Objective

Design and implement a progressive digital platform for the association, based on a **serverless-first architecture**, structured in phases, enabling:

- A stable and updatable online presence  
- Content management by non-technical users  
- Reduction of manual processes  
- Future scalability without structural redesign  

---

## 🗺️ Roadmap

### 🔹 Phase 1 – Digital Presence & Content Management

Scope:

- Public website with the following sections:
  - Home  
  - Club  
  - Courses  
  - New Members  
  - News  
- Administrative panel for content editing  
- News system with main article + historical sidebar  
- Public registration form triggering email notification  
- Authentication via Amazon Cognito (content editors)  
- Fully serverless architecture  

---

### 🔹 Phase 2 – Internal Management & Automation *(Out of Scope for Phase 1)*

- Member accounts  
- Private area  
- Basic member management  
- Communication automation  
- Extended content structure  

---

### 🔹 Phase 3 – Scaling & Transactions *(Future Vision)*

- Online payments  
- Reservations  
- Advanced access control  
- Extended platform capabilities  

---

## 🏗️ Phase 1 Architecture

Serverless architecture built on AWS:

- Public frontend (Astro) deployed on S3 + CloudFront  
- Independent admin panel (separate subdomain)  
- REST API via API Gateway + AWS Lambda (Node.js + TypeScript)  
- DynamoDB tables (`Pages` and `News`)  
- Private S3 bucket for media served via CloudFront  
- Authentication via Amazon Cognito Hosted UI  
- Email notifications via Amazon SES  

### Key Architectural Principles

- Infrastructure as Code (Terraform)  
- Clear separation between public site and admin panel  
- Security by default (private S3 + OAC)  
- Designed for incremental evolution  

---

## 🧱 Design Principles

- Serverless-first  
- Low maintenance  
- Cost-aware architecture  
- Functional simplicity  
- Incremental delivery by phases  
- Clear separation of concerns (Frontend / Backend / Infrastructure)  

---

## 📂 Repository Structure

```
plentzia-piraguismo-platform/
│
├── apps/
│   ├── public-web/      # Web pública (Astro)
│   └── admin-web/       # Panel administrativo (Astro)
│
├── services/
│   └── api/             # AWS Lambda (Node + TypeScript)
│
├── infra/
│   └── terraform/       # Infraestructura como código (AWS)
│
└── README.md
```

## 📌 Current Status

Phase 1 – In Progress.

