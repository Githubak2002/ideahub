# Terraform — Azure Cosmos DB for NoSQL (Dev Phase)

Provisions a **cost-effective, publicly accessible** Azure Cosmos DB for NoSQL
account designed for local FastAPI development and testing.

## Architecture (current phase)

```text
Local FastAPI
     ↓
COSMOS_ENDPOINT + COSMOS_KEY
     ↓
Public Cosmos DB  (Serverless, free-tier)
```

> **Note:** This will later be migrated to a private architecture with AKS
> Workload Identity, UAMI, Private Endpoints, and Private DNS. Those resources
> are intentionally **not** included in this phase.

## What gets provisioned

| Resource | Details |
|---|---|
| Resource Group | `var.resource_group_name` |
| Cosmos DB Account | NoSQL API, Serverless, free-tier, public access, key auth |
| SQL Database | `ideahub` (configurable) |
| SQL Container | `ideas` with partition key `/idea_id` |

## Cost considerations

- **Serverless** — pay only for consumed RU/s (no minimum throughput charge).
- **Free tier** — first 1 000 RU/s + 25 GB storage free per subscription.
- **Single region** — no geo-replication cost.
- **Local backup** — cheapest periodic backup configuration.

## Prerequisites

- [Terraform >= 1.5](https://developer.hashicorp.com/terraform/install)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- An active Azure subscription

## Quick start

```bash
# 1. Authenticate
az login
az account set --subscription <YOUR_SUBSCRIPTION_ID>

# 2. Configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — at minimum set a globally unique cosmosdb_account_name

# 3. Deploy
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan

# 4. Retrieve outputs for your .env file
terraform output cosmosdb_endpoint
terraform output -raw cosmosdb_primary_key
terraform output cosmosdb_database_name
terraform output cosmosdb_container_name
```

## Connecting the FastAPI app

Create an `.env` file in the `app/` directory:

```env
COSMOS_AUTH_MODE=key
COSMOS_ENDPOINT=<output from terraform output cosmosdb_endpoint>
COSMOS_KEY=<output from terraform output -raw cosmosdb_primary_key>
COSMOS_DATABASE=ideahub
COSMOS_CONTAINER=ideas
```

## Cleanup

```bash
terraform destroy
```

## Version decisions

| Component | Version | Rationale |
|---|---|---|
| Terraform CLI | `>= 1.5.0` | Broad compatibility; all HCL features used are stable since 1.5 |
| AzureRM provider | `~> 5.5` | Latest stable (5.5.0), verified via HashiCorp Terraform MCP Server |

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `resource_group_name` | `string` | — | Name of the Azure resource group |
| `location` | `string` | `eastus` | Azure region for all resources |
| `cosmosdb_account_name` | `string` | — | Globally-unique Cosmos DB account name |
| `cosmosdb_database_name` | `string` | `ideahub` | Cosmos DB SQL database name |
| `cosmosdb_container_name` | `string` | `ideas` | Cosmos DB SQL container name |
| `cosmosdb_container_partition_key` | `string` | `/id` | Container partition key path |
| `environment` | `string` | `dev` | Deployment environment label |
| `owner` | `string` | `platform-team` | Resource owner tag |

## Outputs

| Name | Sensitive | Description |
|---|---|---|
| `cosmosdb_endpoint` | No | Cosmos DB account endpoint URL |
| `cosmosdb_primary_key` | **Yes** | Cosmos DB primary key |
| `cosmosdb_connection_string` | **Yes** | Primary SQL connection string |
| `cosmosdb_database_name` | No | Provisioned database name |
| `cosmosdb_container_name` | No | Provisioned container name |
| `resource_group_name` | No | Azure resource group name |
