# AKS Secret Management with Workload Identity + UAMI + Key Vault

## Goal

Store application secrets in **Azure Key Vault** and expose them to the application as normal Kubernetes environment variables without asking developers to change application code.

Architecture:

```text
AKS Pod
  │
  ├── ServiceAccount
  │       │
  │       └── Azure Workload Identity
  │                    │
  │                    ▼
  │               Workload UAMI
  │                    │
  │                    ▼
  │               Key Vault RBAC
  │                    │
  │                    ▼
  │              Azure Key Vault
  │                    │
  │                    ▼
  │          Secrets Store CSI Driver
  │                    │
  │                    ├── mounted volume
  │                    │
  │                    └── Kubernetes Secret
  │                              │
  │                              ▼
  │                         env variables
  │
  └── Application
```

Preferred application consumption method:

```text
Key Vault → SPC → Kubernetes Secret → Deployment env/envFrom
```

The application continues using:

```python
os.environ["STRIPE_API_KEY"]
```

No application-code change is required.

---

## 1. Store secrets in Azure Key Vault

Example secrets:

```text
stripe-api-key
openai-api-key
oauth-client-secret
database-password
```

Example:

```bash
az keyvault secret set   --vault-name <KEYVAULT_NAME>   --name stripe-api-key   --value "<SECRET_VALUE>"
```

Do not store secret values in:

- Git
- Terraform `.tfvars`
- Dockerfile
- Kubernetes YAML
- CI/CD variables unless required

---

## 2. Give the Workload UAMI Key Vault access

Use the existing Workload UAMI.

Grant:

```text
Key Vault Secrets User
```

Example Terraform:

```hcl
resource "azurerm_role_assignment" "workload_keyvault_secrets_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload.principal_id
}
```

Important:

```text
Kubernetes ServiceAccount annotation → UAMI client_id
Azure RBAC role assignment           → UAMI principal_id
```

---

## 3. Enable Azure Key Vault Secrets Provider

Enable the AKS Key Vault Secrets Provider / Secrets Store CSI Driver integration.

Terraform configuration depends on the AzureRM provider version, so verify the exact current schema before adding it to the AKS module.

The resulting AKS setup contains:

```text
AKS
 ├── Workload Identity
 └── Azure Key Vault Secrets Provider
```

---

## 4. ServiceAccount

Reuse the Workload Identity ServiceAccount:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ideahub-sa
  namespace: ideahub
  annotations:
    azure.workload.identity/client-id: "<WORKLOAD_UAMI_CLIENT_ID>"
```

---

## 5. SecretProviderClass

The `SecretProviderClass` tells the CSI provider which Key Vault secrets to retrieve.

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: ideahub-keyvault
  namespace: ideahub

spec:
  provider: azure

  secretObjects:
    - secretName: ideahub-secrets
      type: Opaque
      data:
        - objectName: stripe-api-key
          key: STRIPE_API_KEY

        - objectName: openai-api-key
          key: OPENAI_API_KEY

        - objectName: oauth-client-secret
          key: OAUTH_CLIENT_SECRET

        - objectName: database-password
          key: DATABASE_PASSWORD

  parameters:
    usePodIdentity: "false"

    clientID: "<WORKLOAD_UAMI_CLIENT_ID>"

    keyvaultName: "<KEYVAULT_NAME>"

    tenantId: "<TENANT_ID>"

    objects: |
      array:
        - |
          objectName: stripe-api-key
          objectType: secret
          objectVersion: ""

        - |
          objectName: openai-api-key
          objectType: secret
          objectVersion: ""

        - |
          objectName: oauth-client-secret
          objectType: secret
          objectVersion: ""

        - |
          objectName: database-password
          objectType: secret
          objectVersion: ""
```

The important section for the preferred method is:

```yaml
secretObjects:
```

This causes the CSI provider to create/sync a Kubernetes Secret.

---

## 6. Deployment: mount the CSI volume

The CSI volume must be mounted for the SecretProviderClass to retrieve/sync the secrets.

```yaml
spec:
  template:
    metadata:
      labels:
        azure.workload.identity/use: "true"

    spec:
      serviceAccountName: ideahub-sa

      containers:
        - name: ideahub-api
          image: <IMAGE>

          volumeMounts:
            - name: secrets-store
              mountPath: /mnt/secrets-store
              readOnly: true

      volumes:
        - name: secrets-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: ideahub-keyvault
```

The volume is required even when the application ultimately consumes the values through environment variables.

---

## 7. Deployment: consume the Kubernetes Secret as environment variables

Once the CSI provider has synchronized the secrets:

```yaml
envFrom:
  - secretRef:
      name: ideahub-secrets
```

Example:

```yaml
containers:
  - name: ideahub-api
    image: <IMAGE>

    envFrom:
      - secretRef:
          name: ideahub-secrets

    volumeMounts:
      - name: secrets-store
        mountPath: /mnt/secrets-store
        readOnly: true

volumes:
  - name: secrets-store
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: ideahub-keyvault
```

The application can continue using:

```python
os.environ["STRIPE_API_KEY"]
os.environ["OPENAI_API_KEY"]
os.environ["OAUTH_CLIENT_SECRET"]
os.environ["DATABASE_PASSWORD"]
```

No code change is required.

---

## 8. Complete flow

```text
                    Azure Key Vault
                           │
                     secret value
                           │
                           ▼
                Secrets Store CSI Driver
                           │
                           ▼
                 SecretProviderClass
                           │
                           ▼
                  Kubernetes Secret
                  ideahub-secrets
                           │
                           ▼
                    Deployment
                     envFrom
                           │
                           ▼
                       FastAPI
```

Authentication to Key Vault:

```text
Pod
 │
 ▼
ServiceAccount
 │
 ▼
OIDC / Workload Identity
 │
 ▼
Workload UAMI
 │
 ▼
Key Vault Secrets User
 │
 ▼
Key Vault
```

---

## 9. Verify

Check the ServiceAccount:

```bash
kubectl get sa ideahub-sa -n ideahub -o yaml
```

Check the SecretProviderClass:

```bash
kubectl get secretproviderclass -n ideahub
```

Check the Kubernetes Secret:

```bash
kubectl get secret ideahub-secrets -n ideahub
```

Check the Pod:

```bash
kubectl get pods -n ideahub
```

Verify environment variable names without printing values:

```bash
kubectl exec -n ideahub deploy/ideahub --   env | grep -E 'STRIPE_API_KEY|OPENAI_API_KEY|OAUTH_CLIENT_SECRET|DATABASE_PASSWORD'
```

Do **not** run commands that print the actual secret values in shared terminals/logs.

---

## 10. Important production notes

### Source of truth

```text
Azure Key Vault
      ↓
Kubernetes Secret
```

Key Vault remains the source of truth.

### Secret rotation

When a Key Vault secret changes, the CSI provider can rotate the mounted secret. Applications consuming the value through environment variables generally need a Pod restart to pick up the new environment value.

For automatic restart on secret changes, use an appropriate secret-reload/restart mechanism.

### Prefer identity over secrets

If an Azure service supports Entra ID / Workload Identity authentication, prefer that over storing a password.

Example:

```text
Cosmos DB:
Workload Identity → Cosmos RBAC
```

instead of:

```text
Cosmos DB:
database password → Key Vault → Pod
```

### Least privilege

Grant the Workload UAMI only the Key Vault permissions it needs.

Avoid broad roles such as:

```text
Key Vault Administrator
```

for application workloads.

Preferred:

```text
Key Vault Secrets User
```

for reading secrets.

---

## Production pattern

```text
                  ┌──────────────────┐
                  │   Azure Key Vault│
                  │                  │
                  │ Stripe key       │
                  │ OpenAI key       │
                  │ OAuth secret     │
                  │ DB password      │
                  └────────┬─────────┘
                           │
                    Key Vault RBAC
                           │
                           ▼
                    Workload UAMI
                           ▲
                           │
                    Workload Identity
                           ▲
                           │
                    ServiceAccount
                           ▲
                           │
                    ┌──────┴──────┐
                    │   AKS Pod   │
                    │             │
                    │ CSI volume  │
                    │      │      │
                    │      ▼      │
                    │ K8s Secret  │
                    │      │      │
                    │      ▼      │
                    │ envFrom     │
                    │      │      │
                    │      ▼      │
                    │ FastAPI     │
                    └─────────────┘
```
