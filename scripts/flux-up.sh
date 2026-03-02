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

echo "Starting cluster bootstrap"
flux-operator install \
  -f ./kubernetes/clusters/local/instance.yaml \
  --instance-sync-gha-app-id="${GITHUB_APP_ID}" \
  --instance-sync-gha-installation-owner="${GITHUB_APP_OWNER}" \
  --instance-sync-gha-private-key-file="${CREDS_DIR}/private-key.pem"

echo ""
echo "Waiting for cluster addons sync to complete"
flux-operator -n flux-system wait rset infra --timeout=5m
flux tree kustomization infra-sync

echo "Waiting for apps preview sync to complete"
flux-operator -n flux-system wait rset apps-preview --timeout=5m
flux tree kustomization apps-preview-sync

echo "✔ Cluster is ready"
