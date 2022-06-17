param appName string
param environment string
param region string
param location string = resourceGroup().location
param shouldEnableManagedIdentity bool = false

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    env: environment
  }
}

module managedIdentityDeployment 'managed-identity.bicep' = {
  name: 'managed-identity-deployment'
  params: {
    location: location
    managedIdentityName: names.outputs.managedIdentityName
  }
}

module loggingDeployment 'logging.bicep' = {
  name: 'logging-deployment'
  params: {
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
    location: location
    appInsightsName: names.outputs.appInsightsName
    appServiceNetCoreName: names.outputs.appServiceNetCoreName
    appServiceJavaName: names.outputs.appServiceJavaName
  }
}

module storageDeployment 'storage.bicep' = {
  name: 'storage-deployment'
  params: {
    blobContainerName: names.outputs.blobContainerName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    storageAccountName: names.outputs.storageAccountName
    shouldEnableManagedIdentity: shouldEnableManagedIdentity
  }
}

module keyVaultDeployment 'key-vault.bicep' = {
  name: 'key-vault-deployment'
  params: {
    keyVaultName: names.outputs.keyVaultName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    storageAccountName: storageDeployment.outputs.storageAccountName
    storageAccountAccessKeySecretName: names.outputs.storageAccountAccessKeySecretName
  }
}

module appServicePlanDeployment 'app-service-plan.bicep' = {
  name: 'app-service-plan-deployment'
  params: {
    appServicePlanName: names.outputs.appServicePlanName
    location: location
  }
}

module appServiceNetCoreDeployment 'app-service-net-core.bicep' = {
  name: 'app-service-net-core-deployment'
  params: {
    appInsightsName: loggingDeployment.outputs.appInsightsName
    appServiceNetCoreName: names.outputs.appServiceNetCoreName
    appServicePlanName: appServicePlanDeployment.outputs.appServicePlanName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    storageAccountName: storageDeployment.outputs.storageAccountName
    storageAccountAccessKeySecretName: keyVaultDeployment.outputs.storageAccountAccessKeySecretName
    blobContainerName: storageDeployment.outputs.blobContainerName
    shouldEnableManagedIdentity: shouldEnableManagedIdentity
  }
}

module appServiceJavaDeployment 'app-service-java.bicep' = {
  name: 'app-service-java-deployment'
  params: {
    appInsightsName: loggingDeployment.outputs.appInsightsName
    appServiceJavaName: names.outputs.appServiceJavaName
    appServicePlanName: appServicePlanDeployment.outputs.appServicePlanName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    blobContainerName: storageDeployment.outputs.blobContainerName
    shouldEnableManagedIdentity: shouldEnableManagedIdentity
    storageAccountAccessKeySecretName: keyVaultDeployment.outputs.storageAccountAccessKeySecretName
    storageAccountName: storageDeployment.outputs.storageAccountName
  }
}
