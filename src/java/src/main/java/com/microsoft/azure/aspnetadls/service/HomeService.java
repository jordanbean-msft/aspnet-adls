package com.microsoft.azure.aspnetadls.service;

import java.nio.charset.StandardCharsets;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.azure.core.credential.TokenCredential;
import com.azure.core.http.rest.PagedIterable;
import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.storage.common.StorageSharedKeyCredential;
import com.azure.storage.file.datalake.DataLakeDirectoryClient;
import com.azure.storage.file.datalake.DataLakeFileClient;
import com.azure.storage.file.datalake.DataLakeFileSystemClient;
import com.azure.storage.file.datalake.DataLakeServiceClient;
import com.azure.storage.file.datalake.DataLakeServiceClientBuilder;
import com.azure.storage.file.datalake.models.ListPathsOptions;
import com.azure.storage.file.datalake.models.PathItem;
import com.azure.storage.file.datalake.models.AccessControlChangeCounters;
import com.azure.storage.file.datalake.models.AccessControlChangeResult;
import com.azure.storage.file.datalake.models.AccessControlType;
import com.azure.storage.file.datalake.models.PathAccessControl;
import com.azure.storage.file.datalake.models.PathAccessControlEntry;
import com.azure.storage.file.datalake.models.PathPermissions;
import com.azure.storage.file.datalake.models.PathRemoveAccessControlEntry;
import com.azure.storage.file.datalake.models.RolePermissions;
import com.azure.storage.file.datalake.options.PathSetAccessControlRecursiveOptions;
import com.microsoft.azure.aspnetadls.ConfigProperties;
import com.microsoft.azure.aspnetadls.model.JsonFile;

@Service
public class HomeService {
  private ConfigProperties configProperties;

  @Autowired
  public void setConfigProperties(ConfigProperties configProperties) {
    this.configProperties = configProperties;
  }

  private DataLakeServiceClientService dataLakeServiceClientService;

  @Autowired
  public void setDataLakeServiceClientService(DataLakeServiceClientService dataLakeServiceClientService) {
    this.dataLakeServiceClientService = dataLakeServiceClientService;
  }

  public Vector<JsonFile> getJsonFiles() {
    Vector<JsonFile> jsonFiles = new Vector<JsonFile>();

    var dataLakeServiceClient = dataLakeServiceClientService.getDataLakeServiceClient();

    var fileSystemClient = dataLakeServiceClient.getFileSystemClient(configProperties.getBlobContainerName());

    for (var path : fileSystemClient.listPaths(new ListPathsOptions().setPath("/").setRecursive(true), null)) {
      if (path.isDirectory() == false) {
        var fileClient = fileSystemClient.getFileClient(path.getName());
        var fileStream = fileClient.openInputStream();
        var jsonFile = new JsonFile();
        jsonFile.setName(path.getName());
        try {
          jsonFile.setContent(new String(fileStream.getInputStream().readAllBytes(), StandardCharsets.UTF_8));
        } catch (Exception e) {
          jsonFile.setContent("Unable to load file");
        }
        jsonFiles.add(jsonFile);
      }
    }

    return jsonFiles;
  }
}
