package com.microsoft.azure.aspnetadls;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "azure")
public class ConfigProperties {
  private String blobContainerName;

  public String getBlobContainerName() {
    return blobContainerName;
  }

  public void setBlobContainerName(String blobContainerName) {
    this.blobContainerName = blobContainerName;
  }

  private String managedIdentityClientId;

  public String getManagedIdentityClientId() {
    return managedIdentityClientId;
  }

  public void setManagedIdentityClientId(String managedIdentityClientId) {
    this.managedIdentityClientId = managedIdentityClientId;
  }

  private String storageAccountAccessKey;

  public String getStorageAccountAccessKey() {
    return storageAccountAccessKey;
  }

  public void setStorageAccountAccessKey(String storageAccountAccessKey) {
    this.storageAccountAccessKey = storageAccountAccessKey;
  }

  private String storageAccountName;

  public String getStorageAccountName() {
    return storageAccountName;
  }

  public void setStorageAccountName(String storageAccountName) {
    this.storageAccountName = storageAccountName;
  }

  private String useManagedIdentity;

  public boolean isUseManagedIdentity() {
    return Boolean.parseBoolean(useManagedIdentity);
  }

  public void setUseManagedIdentity(String useManagedIdentity) {
    this.useManagedIdentity = useManagedIdentity;
  }
}
