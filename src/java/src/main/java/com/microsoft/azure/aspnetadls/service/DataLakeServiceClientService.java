package com.microsoft.azure.aspnetadls.service;

import java.util.Vector;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.storage.common.StorageSharedKeyCredential;
import com.azure.storage.file.datalake.DataLakeServiceClient;
import com.azure.storage.file.datalake.DataLakeServiceClientBuilder;
import com.microsoft.azure.aspnetadls.ConfigProperties;

@Service
public class DataLakeServiceClientService {
  private ConfigProperties configProperties;

  @Autowired
  public void setConfigProperties(ConfigProperties configProperties) {
    this.configProperties = configProperties;
  }

  @PostConstruct
  public DataLakeServiceClient getDataLakeServiceClient() {
    String endpoint = "https://" + configProperties.getStorageAccountName() + ".dfs.core.windows.net";
    DataLakeServiceClient dataLakeServiceClient;
    if (configProperties.isUseManagedIdentity()) {

      DefaultAzureCredential defaultAzureCredential = new DefaultAzureCredentialBuilder()
          .managedIdentityClientId(configProperties.getManagedIdentityClientId())
          .build();

      DataLakeServiceClientBuilder builder = new DataLakeServiceClientBuilder();
      dataLakeServiceClient = builder.credential(defaultAzureCredential).endpoint(endpoint).buildClient();
    } else {
      StorageSharedKeyCredential sharedKeyCredential = new StorageSharedKeyCredential(
          configProperties.getStorageAccountName(), configProperties.getStorageAccountAccessKey());

      DataLakeServiceClientBuilder builder = new DataLakeServiceClientBuilder();

      builder.credential(sharedKeyCredential);
      builder.endpoint(endpoint);

      dataLakeServiceClient = builder.buildClient();
    }
    return dataLakeServiceClient;
  }
}
