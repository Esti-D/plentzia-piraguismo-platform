# plentzia-piraguismo-platform
## 🧭 Contexto

El Club de Piragüismo de Plentzia no dispone actualmente de una plataforma digital funcional.  
La presencia online se limita a un blog desactualizado y los procesos administrativos (inscripciones, comunicación y publicación de información) se gestionan de forma manual.

Existe además una rotación natural de responsables dentro de la asociación, lo que exige una solución:

- Sencilla de usar  
- Sostenible en el tiempo  
- Sin dependencia técnica constante  
- De bajo coste operativo  

---

## 🎯 Objetivo del Proyecto

Diseñar e implementar una plataforma digital progresiva para la asociación, basada en arquitectura **serverless** y estructurada por fases, que permita:

- Presencia online estable y actualizable  
- Publicación sencilla de contenido por parte de usuarios no técnicos  
- Reducción de procesos manuales  
- Escalabilidad futura sin rediseños estructurales  

---

## 🗺️ Roadmap por Fases

### 🔹 Fase 1 – Presencia Digital y Gestión de Contenido

**Alcance:**

- Web pública con las siguientes secciones:
  - Home  
  - Club  
  - Cursillos  
  - Nuevos Miembros  
  - Noticias  
- Publicación y edición de contenido mediante panel administrativo  
- Noticias con estructura principal + histórico lateral  
- Formulario público de inscripción que genera notificación por email  
- Autenticación mediante Amazon Cognito (usuarios editores)  
- Arquitectura serverless sin servidores persistentes  

---

### 🔹 Fase 2 – Gestión Interna y Automatización *(No incluida en Fase 1)*

- Usuarios socios  
- Área privada  
- Gestión básica de socios  
- Automatizaciones de comunicación  
- Evolución de estructura de contenidos  

---

### 🔹 Fase 3 – Escalado y Transacciones *(Visión futura)*

- Pagos online  
- Reservas  
- Mayor control de acceso  
- Funcionalidades avanzadas  

---

## 🏗️ Arquitectura Fase 1

Arquitectura serverless basada en AWS:

- Frontend público (Astro) desplegado en S3 + CloudFront  
- Panel administrativo independiente (subdominio)  
- API REST mediante API Gateway + AWS Lambda (Node + TypeScript)  
- Base de datos DynamoDB (tablas `Pages` y `News`)  
- Almacenamiento de imágenes en S3 privado servido por CloudFront  
- Autenticación mediante Amazon Cognito Hosted UI  
- Envío de emails mediante Amazon SES  

### Principios clave

- Infraestructura como código (Terraform)  
- Separación entre web pública y panel administrativo  
- Seguridad por defecto (S3 privado, acceso mediante OAC)  
- Arquitectura preparada para evolución futura  

---

## 🧱 Principios de Diseño

- Serverless-first  
- Low maintenance  
- Cost-aware architecture  
- Simplicidad funcional  
- Evolución incremental por fases  
- Separación clara entre capas (Frontend / Backend / Infra)  

---

## 📂 Estructura del Repositorio

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

## 📌 Estado Actual

Proyecto en desarrollo – Fase 1.
