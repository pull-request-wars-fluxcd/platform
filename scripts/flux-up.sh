#!/usr/bin/env bash

# Copyright 2026 Stefan Prodan
# SPDX-License-Identifier: Apache-2.0

set -o errexit

echo "Configuring GitHub App credentials"

CREDS_DIR="github-app-auth"
if [ ! -f "${CREDS_DIR}/.env" ]; then
  echo "Error: ${CREDS_DIR}/.env not found. See README.md for setup instructions."
  exit 1
fi
if [ ! -f "${CREDS_DIR}/private-key.pem" ]; then
  echo "Error: ${CREDS_DIR}/private-key.pem not found. See README.md for setup instructions."
  exit 1
fi

source "${CREDS_DIR}/.env"

kubectl get namespace flux-system > /dev/null 2>&1 || kubectl create namespace flux-system

flux-operator create secret githubapp github-app-auth \
  --namespace=flux-system \
  --app-id="${GITHUB_APP_ID}" \
  --app-installation-id="${GITHUB_APP_INSTALLATION_ID}" \
  --app-private-key-file="${CREDS_DIR}/private-key.pem"

echo "Starting cluster bootstrap"
flux-operator install -f ./kubernetes/clusters/local/instance.yaml

echo ""
echo "Waiting for cluster addons sync to complete"
flux-operator -n flux-system wait rset infra --timeout=5m
flux tree kustomization infra-sync

echo "Waiting for apps preview sync to complete"
flux-operator -n flux-system wait rset apps-preview --timeout=5m
flux tree kustomization apps-preview-sync

echo "✔ Cluster is ready"
