#!/bin/bash

# Ensure docker image exists and is accessible
IMAGE_NAME="ghcr.io/rsmartins78/gitops-argocd-lab"
IMAGE_TAG="latest"

if ! docker pull ${IMAGE_NAME}:${IMAGE_TAG}; then
  echo "Docker image ${IMAGE_NAME}:${IMAGE_TAG} not found."
  echo "Please wait until the image is built."
  exit 1
fi

kubectl apply -n argocd -f infra/argo/applicationset.yaml

echo "ArgoCD ApplicationSet deployed."