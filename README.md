# aspnet-adls

## Infrastructure

```shell
az deployment group create -g rg-aspnet-adls-ussc-dev --template-file ./infra/main.bicep --parameters ./infra/env/dev.parameters.json --parameters shouldEnableManagedIdentity=false
```

## ASPNET Core

```shell
dotnet publish
Compress-Archive ./bin/Debug/net6.0/publish/* ../app.zip -Update
az webapp deployment source config-zip --resource-group rg-aspnet-adls-ussc-dev --name wa-net-core-aspnetadls-ussc-dev --src ../app.zip
```

## Java

```shell
gradle bootRun
gradle azureWebAppDeploy
```
