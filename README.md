# GitOps ArgoCD Lab

This repository demonstrates a production-grade, GitOps-managed deployment of a stateless Flask application on Kubernetes using Helm and ArgoCD. It supports multi-environment (dev, prd) deployments, security best practices, and scalable, DRY configuration.

## Repository Structure

- `app/` — Flask application, Dockerfile, and requirements
- `infra/chart/` — Helm chart for the application
  - `values.yaml` — Default (dev) environment values
  - `values-prd.yaml` — Production environment values
  - `templates/` — Kubernetes manifests (Deployment, Service, Ingress, HPA, PDB, NetworkPolicy, ResourceQuota, etc.)
- `infra/argo/applicationset.yaml` — ArgoCD ApplicationSet for multi-environment GitOps.
- `deploy.sh` — Script to verify Docker image and trigger deployment.
- `SOLUTION.md` — Design decisions, justifications, and explanations.

## Prerequisites

- Docker
- kubectl
- Helm
- Minikube

## Setup & Deployment

### 1. Start Kubernetes Cluster

- Start Minikube and install ArgoCD
  ```sh
  ./setup.sh
  ```
- It will print the admin password and the command to port-forward Argo server port, so you can access it.

### 2. Deploy the Application via ArgoCD

- Run the deploy script to build and push the Docker image, and update the Helm values:
  ```sh
  ./deploy.sh
  ```
  This will apply the ArgoCD ApplicationSet using kubectl.

### 3. Access ArgoCD

- Port-forward the ArgoCD UI:
  ```sh
  kubectl port-forward svc/argocd-server -n argocd 8080:443
  ```
- Access the UI at https://localhost:8080 (default user: admin, password: see below)
- If you didn't store the password after running `./setup.sh`, retrieve it again running `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`.

### 4. Access the Application

- Port-forward the service:
  ```sh
  kubectl port-forward deployment/app-dev -n dev 8000:8000
  ```
  or 
  ```sh
  kubectl port-forward deployment/app-prd -n prd 8000:8000
  ```

## Customization

- Edit `infra/chart/values-dev.yaml` and `infra/chart/values-prd.yaml` for environment-specific settings (replicas, resources, ingress, HPA, etc.).
- Edit `infra/chart/values.yaml` for default settings.
- Add more environments by extending the ApplicationSet and adding new values files.
- Enable/disable Ingress and HPA per environment via values files (disabled by default).

## Troubleshooting

- Ensure all prerequisites are installed.
- For Minikube, ensure ingress and metrics-server addons are enabled.
- Check ArgoCD UI for sync and health status.

---

For detailed design decisions and justifications, see `SOLUTION.md`.
