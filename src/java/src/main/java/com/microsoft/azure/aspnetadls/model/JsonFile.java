package com.microsoft.azure.aspnetadls.model;

public class JsonFile {
  private String Name;

  public String getName() {
    return Name;
  }

  public void setName(String name) {
    Name = name;
  }

  private String Content;

  public String getContent() {
    return Content;
  }

  public void setContent(String content) {
    Content = content;
  }
}
