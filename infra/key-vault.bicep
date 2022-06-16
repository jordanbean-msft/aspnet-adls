param keyVaultName string
param location string
param managedIdentityName string
param logAnalyticsWorkspaceName string
param storageAccountName string
param storageAccountConnectionStringSecretName string
param storageAccountAccessKeySecretName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: false
    accessPolicies: [
      {
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
        objectId: managedIdentity.properties.principalId
        tenantId: managedIdentity.properties.tenantId
      }
    ]
  }
  resource storageAccountConnectionStringSecret 'secrets@2021-10-01' = {
    name: storageAccountConnectionStringSecretName
    properties: {
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
    }
  }
  resource storageAccountAccessKeySecret 'secrets@2021-10-01' = {
    name: storageAccountAccessKeySecretName
    properties: {
      value: storageAccount.listKeys().keys[0].value
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
      {
        category: 'AzurePolicyEvaluationDetails'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output keyVaultName string = keyVault.name
output storageAccountConnectionStringSecretName string = storageAccountConnectionStringSecretName
output storageAccountAccessKeySecretName string = storageAccountAccessKeySecretName
