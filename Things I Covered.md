## Phase 1 - Key based Auth

**Python Fast API running locally (container) and connecting to Azure Cosmos DB for NOSQL using key based Auth (Dev Phase)**

- first created a simpe py based - fast API that would store the data in Azure CosmoDB
- manually created a cosmosDB from Azure portal UI (key based auth, cost optimized, SQL DB: ideahub, Container: ideas, container partation key : /id, Cosmos DB Serverless capacity)
- tested the py fast api (running locally on Docker container) with CosmosDB (key based auth)
- deleted the Azure CosmosDB (from Azure portal)

- Extra - provisioned entire infra using terraform 
- Extra - created a terrafrom agent skill to create the IaC and utilized tf MCP server to use tools such as - search_providers, get_latest_provider_version, search_modules, get_modules_details, etc
- Extra - created the entire IaC utilizing ag cli, tf agent skills (the one we created), TF MCP server


## Phase 2 - Workload identity Federation based Auth
- provisioned the infra using tf (private DynamoDB, Private AKS, Public Jump VM, private endpoint, private DNS zone, Networking, federation, UAMI, etc)
- created the required manifests file to deploy the app on k8s cluster 
- deployed the app on private AKS via Jump VM
- tested the app 

- Extra - provisioned entire infra using terraform following the best practices (made use of the tf skill and tf MCP server)

## Phase 3 - 
- added config map
- proper logging

TODO: 
- app env - cosmosDB endpoint, container name (get the app env from keyvault and use as k8s secret) -> use configmap and not secret (key vault)
- py fast api - update the app to get the app logs in a prod ready way and crear logs (add curl dummy api call for testing them in app dir)
- monitor - how do we monitor the app logs? etc?
IMPORTANT: 
- explore the k8s - deployment and other file -> probs (should hit the endpoints only at the pod creation time?)
- explore the TF code and how we implemented the workload identity federation ?
- 
- 