README.md
🏗️ Homelab Platform: Kubernetes + FluxCD + Terraform
A fully GitOps‑driven homelab platform built on Kubernetes, managed end‑to‑end with FluxCD and Terraform.
This project demonstrates real‑world platform engineering patterns: declarative infrastructure, GitOps workflows, automated deployments, observability, and secrets management.

📐 Architecture Overview
Your development environment is your desktop, which controls the entire platform through Git and CLI tools.

Code
┌──────────────────────────┐
│        Desktop Dev       │
│  - kubectl               │
│  - terraform             │
│  - flux CLI              │
│  - VS Code               │
└─────────────┬────────────┘
              │
              │ Push changes
              ▼
┌──────────────────────────┐
│        Git Repos         │
│  infra-homelab (TF)      │
│  cluster-gitops (Flux)   │
└─────────────┬────────────┘
              │ Flux pulls
              ▼
┌──────────────────────────┐
│     Kubernetes Cluster    │
│  - FluxCD                 │
│  - Ingress Controller     │
│  - cert-manager           │
│  - Prometheus/Grafana     │
│  - Loki                   │
│  - Demo apps              │
└──────────────────────────┘
📁 Repository Structure
1. infra-homelab (Terraform)
Infrastructure provisioning.

Code
infra-homelab/
  modules/
  envs/
    dev/
      main.tf
      variables.tf
      outputs.tf
2. cluster-gitops (FluxCD)
Cluster configuration + apps.

Code
cluster-gitops/
  clusters/
    dev/
      flux-system/
      infrastructure/
      apps/
  apps/
    ingress-nginx/
    cert-manager/
    monitoring/
    demo-app/
🚀 Step 1 — Provision Infrastructure (Terraform)
Use Terraform to create your Kubernetes environment.

Depending on your setup, Terraform may:

Create a VM and install k3s

Provision a managed cluster (EKS/AKS/GKE)

Configure networking and DNS

Output your kubeconfig

After applying:

bash
terraform apply
export KUBECONFIG=~/kubeconfigs/homelab-dev.yaml
kubectl get nodes
You should see your cluster.

🚀 Step 2 — Bootstrap FluxCD
Install Flux on your desktop, then bootstrap the cluster:

bash
flux bootstrap github \
  --owner=YOUR_GITHUB_USERNAME \
  --repository=cluster-gitops \
  --branch=main \
  --path=clusters/dev \
  --personal
Flux installs itself and begins reconciling the clusters/dev directory.

🧩 Step 3 — Install Core Platform Components
All platform components live in cluster-gitops/apps/.

Ingress Controller
apps/ingress-nginx/HelmRelease.yaml

cert-manager
apps/cert-manager/HelmRelease.yaml

Secrets Management (SOPS + age)
Encrypted secrets stored safely in Git.

External DNS (optional)
Automates DNS record creation.

Wire these into the cluster via a Kustomization:

yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infrastructure
  namespace: flux-system
spec:
  path: ./apps
  prune: true
  sourceRef:
    kind: GitRepository
    name: cluster-gitops
📊 Step 4 — Add Observability Stack
Inside apps/monitoring/:

Prometheus

Grafana

Loki

Expose Grafana via ingress for dashboards.

Commit and push → Flux deploys automatically.

🧪 Step 5 — Deploy a Demo Application
Example structure:

Code
apps/demo-app/
  deployment.yaml
  service.yaml
  ingress.yaml
Add a Kustomization under:

Code
clusters/dev/apps/
Push → Flux deploys.

Verify:

bash
kubectl get pods -n demo-app
kubectl get ingress -n demo-app
🛠️ Local Development Workflow
Your desktop is the control plane for everything.

Daily workflow:
Edit YAML/Helm/Terraform

Validate locally

Commit + push

Flux reconciles

Cluster updates automatically

Useful commands:

bash
flux get kustomizations
flux get helmreleases
kubectl get pods -A
📘 Documentation
This project demonstrates:

Declarative infrastructure (Terraform)

GitOps-driven cluster management (FluxCD)

Kubernetes platform components

Observability stack

Secrets encryption

Automated deployments

Real platform engineering workflows

🧭 Future Enhancements
Multi-cluster GitOps

Service mesh (Linkerd/Istio)

Canary deployments (Flagger)

Backstage developer portal

External DNS automation

Automated cluster upgrades
