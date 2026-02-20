# platform

## Prerequisites

### Repository setup

Fork the platform repository in your own GitHub organization and clone it locally.

Change the GitHub repository URL in `kubernetes/clusters/local/instance.yaml`
to point to your forked repository. Commit and push the changes to your fork.

### GitHub App setup

Create a GitHub App in your organization with the following permissions:
- Repository permissions:
  - Commit statuses: Read and write
  - Contents: Read-only
  - Pull requests: Read and write

Install the GitHub App in your organization.

Create the `github-app-auth` directory and add your GitHub App credentials:

```bash
mkdir -p github-app-auth
```

Create `github-app-auth/.env` with the following content:

```bash
GITHUB_APP_ID=<your-app-id>
GITHUB_APP_INSTALLATION_ID=<your-app-installation-id>
```

Copy your GitHub App private key to `github-app-auth/private-key.pem`.

You can find the App ID in your GitHub App settings
under **Settings > Developer settings > GitHub Apps**.

The private key can be generated from the same page under **Private keys**.

The installation ID is available in the URL of your GitHub App installation
under **Settings > Developer settings > GitHub Apps > Your App > Installations**.

## Cluster bootstrap

Start the dev environment with:

```bash
make up
```
