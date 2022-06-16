param storageAccountName string
param blobContainerName string
param location string
param managedIdentityName string
param logAnalyticsWorkspaceName string
param shouldEnableManagedIdentity bool

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing = {
  name: managedIdentityName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'BlockBlobStorage'
  properties: {
    isHnsEnabled: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  name: '${storageAccount.name}/default'
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${blobService.name}/${blobContainerName}'
  properties: {
  }
}

var storageBlobDataReaderRoleDefinition = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'

resource managedIdentityStorageBlobDataReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = if (shouldEnableManagedIdentity) {
  name: guid(managedIdentity.id, resourceGroup().name, storageBlobDataReaderRoleDefinition)
  scope: blobContainer
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: storageBlobDataReaderRoleDefinition
  }
}

resource diagnosticSettingsStorageAccount 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'StorageAccountLogging'
  scope: storageAccount
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: []
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

resource diagnosticSettingsBlobContainer 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'BlobContainerLogging'
  scope: blobService
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

output storageAccountName string = storageAccount.name
output blobContainerName string = blobContainerName
