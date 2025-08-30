#!/usr/bin/env bash

# Function to check if a command is installed
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo >&2 "$1 is not installed. Please install it and try again."
        exit 1
    }
}

echo "Checking for required packages..."
check_command kubectl
check_command docker
check_command minikube

echo "Starting Minikube with 1 control plane and 3 worker nodes."
minikube start --nodes 4 --driver=docker

echo "Enable ingress and metrics-server addons."
minikube addons enable ingress
minikube addons enable metrics-server

echo "Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=available --timeout=60s deployment/argocd-server -n argocd

sleep 10
echo "Retrieving ArgoCD admin password..."
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo -e "To access Argo server, run the following command:
$ kubectl port-forward svc/argocd-server -n argocd 8080:443
Then open your browser and go to http://localhost:8080; Use the password retrieved above."
