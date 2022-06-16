param appName string
param region string
param env string

output appInsightsName string = 'ai-${appName}-${region}-${env}'
output logAnalyticsWorkspaceName string = 'la-${appName}-${region}-${env}'
output appServicePlanName string = 'asp-${appName}-${region}-${env}'
output appServiceNetCoreName string = 'wa-net-core-${appName}-${region}-${env}'
output appServiceJavaName string = 'wa-java-${appName}-${region}-${env}'
output keyVaultName string = 'kv-${appName}-${region}-${env}'
output managedIdentityName string = 'mi-${appName}-${region}-${env}'
output storageAccountName string = toLower('sa${appName}${region}${env}')
output blobContainerName string = 'blobs'
output storageAccountConnectionStringSecretName string = 'sa${appName}${region}${env}-connection-string'
output storageAccountAccessKeySecretName string = 'sa${appName}${region}${env}-access-key'
