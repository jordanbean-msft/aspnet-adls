param location string
param appServicePlanName string
param appServiceJavaName string
param managedIdentityName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param keyVaultName string
param storageAccountConnectionStringSecretName string
param storageAccountName string
param storageAccountAccessKeySecretName string
param blobContainerName string
param shouldEnableManagedIdentity bool

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: appServicePlanName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing = {
  name: managedIdentityName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource appServiceJava 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceJavaName
  location: location
  kind: 'app,windows'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {

    serverFarmId: appServicePlan.id
    keyVaultReferenceIdentity: managedIdentity.id
    siteConfig: {
      javaVersion: '1.8'
      javaContainer: 'Tomcat'
      javaContainerVersion: '9.0'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'Recommended'
        }
        {
          name: 'StorageAccountName'
          value: storageAccountName
        }
        {
          name: 'UseManagedIdentity'
          value: ((shouldEnableManagedIdentity) ? 'true' : 'false')
        }
        {
          name: 'StorageAccountAccessKey'
          value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${storageAccountAccessKeySecretName})'
        }
        {
          name: 'ManagedIdentityClientId'
          value: managedIdentity.properties.clientId
        }
        {
          name: 'BlobContainerName'
          value: blobContainerName
        }
      ]
      connectionStrings: [
        {
          name: 'StorageAccountConnectionString'
          connectionString: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${storageAccountConnectionStringSecretName})'
          type: 'Custom'
        }
      ]
    }
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: appServiceJava
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
      {
        category: 'AppServiceIPSecAuditLogs'
        enabled: true
      }
      {
        category: 'AppServicePlatformLogs'
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

output appServicePlanName string = appServicePlan.name
output appServiceJavaName string = appServiceJava.name
