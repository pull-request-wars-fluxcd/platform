# Makefile for deploying the Flux Operator on a Kubernetes KinD cluster
# and syncing it with a Git repo as the cluster desired state.

# Prerequisites:
# - Docker
# - Kind
# - Kubectl
# - Flux CLI
# - Flux Operator CLI

SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

.PHONY: all
all: up

##@ General

.PHONY: up
up: cluster-up flux-up ## Create the local cluster and registry, install Flux and the cluster addons

.PHONY: down
down: cluster-down ## Delete the local cluster and registry

.PHONY: sync
sync: flux-sync ## Push and reconcile the manifests with the cluster
	git add -A && git commit -m "Sync cluster state" && git push
	./scripts/flux-sync.sh

.PHONY: ls
ls: ## List all deployed resources
	flux-operator -n flux-system tree ks flux-system

##@ Cluster

cluster-up: ## Creates a Kubernetes KinD cluster and a local registry bind to localhost:5050.
	./scripts/kind-up.sh

cluster-down: ## Shutdown the Kubernetes KinD cluster and the local registry.
	./scripts/kind-down.sh

##@ Flux

flux-up: ## Deploy Flux Operator on the Kubernetes KinD cluster.
	./scripts/flux-up.sh

flux-sync: ## Sync the local cluster with the remote Git repository.
	./scripts/flux-sync.sh

##@ Help

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
