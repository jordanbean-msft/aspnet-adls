package com.microsoft.azure.aspnetadls.controller;

import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;

import com.microsoft.azure.aspnetadls.model.JsonFile;
import com.microsoft.azure.aspnetadls.service.HomeService;

@Controller
public class HomeController {

  @Autowired
  HomeService homeService;

  @GetMapping("/")
  public String index(ModelMap model) {
    Vector<JsonFile> jsonFiles = new Vector<JsonFile>();
    jsonFiles = homeService.getJsonFiles();
    model.put("jsonFiles", jsonFiles);
    return "index";
  }

}
