#!/usr/bin/env bash

echo "Deploying ArgoCD ApplicationSet..."
kubectl apply -n argocd -f infra/argo/applicationset.yaml
echo "ArgoCD ApplicationSet deployed."
echo "It may take a while for the ApplicationSet to be processed and the applications to be created."

