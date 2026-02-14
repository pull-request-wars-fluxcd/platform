#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan
# SPDX-License-Identifier: Apache-2.0

set -o errexit

echo "Waiting for cluster sync to complete"
flux reconcile kustomization flux-system --with-source

echo "✔ Cluster is in sync"
