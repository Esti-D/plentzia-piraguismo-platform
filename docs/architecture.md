# Architecture Overview – Phase 1

## 1. Objective

Design and implement a serverless-first digital platform for a local sports association, prioritizing:

- Low operational maintenance
- Cost efficiency
- Content management by non-technical users
- Future scalability through phased evolution

---

## 2. Architectural Principles

- Serverless-first approach
- Separation of concerns (Public / Admin / API / Infrastructure)
- Security by default
- Infrastructure as Code
- Incremental delivery

---

## 3. High-Level Architecture

### Frontend

- Public website (Astro) deployed on S3 + CloudFront
- Admin panel (Astro) deployed on separate S3 + CloudFront
- Admin accessible via dedicated subdomain

### Backend

- API Gateway (HTTP API)
- AWS Lambda (Node.js + TypeScript)
- RESTful endpoints

### Data Layer

- DynamoDB table: `Pages`
- DynamoDB table: `News`
- GSI on `News` for latest article retrieval

### Media Storage

- Private S3 bucket
- Served via CloudFront
- Pre-signed URLs for uploads (admin only)

### Authentication

- Amazon Cognito Hosted UI
- Single user type: content editors
- Admin routes protected

### Email Integration

- Amazon SES
- Used for public "New Members" form notifications

---

## 4. Data Model (Conceptual)

### Pages Table

- slug (PK)
- title
- heroImageKey
- body
- sections
- updatedAt
- updatedBy

### News Table

- newsId (PK)
- title
- body
- heroImageKey
- galleryImageKeys
- publishedAt
- updatedAt
- updatedBy

---

## 5. Scope Boundaries (Phase 1)

Included:
- Editable institutional content
- News system (main + historical)
- Admin panel authentication
- Email notification form

Excluded:
- Member accounts
- Private member area
- Payments
- Automated workflows

---

## 6. Future Evolution (Phase 2+)

- Member authentication
- Role-based access
- Private document area
- Payment integration
- Extended automation