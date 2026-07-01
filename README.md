# Frontend - Gestión de Productos

Frontend en Java/Maven que genera una página estática HTML servida por Nginx, desplegada en AWS ECS Fargate.

## Arquitectura

- **Tecnología**: Java 17 + Maven + Nginx
- **Contenedor**: Docker (imagen multi-stage: Maven para compilar, Nginx para servir)
- **Orquestación**: AWS ECS Fargate
- **Registro de imágenes**: Amazon ECR
- **Balanceador**: Application Load Balancer (ALB)
- **URL pública**: http://eval3-alb-810585078.us-east-1.elb.amazonaws.com

## Funcionalidades

- Catálogo de productos (consume `/api/products` via ALB → product-service)
- Registro de usuarios (consume `/api/users` via ALB → user-service)
- Diseño responsivo

## Pipeline CI/CD

Cada commit a `main` dispara automáticamente el workflow `.github/workflows/deploy.yml`:
1. **Build**: compila el proyecto y construye la imagen Docker
2. **Push**: sube la imagen a Amazon ECR
3. **Deploy**: fuerza un nuevo despliegue en ECS (`update-service --force-new-deployment`)

## Variables de entorno

| Variable | Descripción |
|----------|-------------|
| No requiere variables de entorno en runtime | El frontend es estático servido por Nginx |

## Autoscaling

Configurado con Target Tracking al 50% de CPU:
- Mínimo: 1 task
- Máximo: 3 tasks
- Si CPU supera 50%, ECS agrega tasks automáticamente

## Cómo ejecutar localmente

```bash
mvn clean compile exec:java
```
Abre `output/index.html` en el navegador.

## Estructura del proyecto

