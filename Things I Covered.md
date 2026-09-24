

## Phase 1 - Key based Auth

**Python Fast API running locally (container) and connecting to Azure Cosmos DB for NOSQL using key based Auth (Dev Phase)**

- first created a simpe py based - fast API that would store the data in Azure CosmoDB
- manually created a cosmosDB from Azure portal UI (key based auth, cost optimized, SQL DB: ideahub, Container: ideas, container partation key : /id, Cosmos DB Serverless capacity)
- tested the py fast api (running locally on Docker container) with CosmosDB (key based auth)
- deleted the Azure CosmosDB (from Azure portal)

- provisioned entire infra using terraform 
- Extra - created a terrafrom agent skill to create the IaC and utilized tf MCP server to use tools such as - search_providers, get_latest_provider_version, search_modules, get_modules_details, etc
- Extra - created the entire IaC utilizing ag cli, tf agent skills (the one we created), TF MCP server



