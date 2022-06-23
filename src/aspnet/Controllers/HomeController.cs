using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using aspnet_adls.Models;
using Azure.Storage.Files.DataLake;
using Azure.Storage.Files.DataLake.Models;

namespace aspnet_adls.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly DataLakeServiceClient _dataLakeServiceClient;
    private readonly IConfiguration _configuration;

    public HomeController(ILogger<HomeController> logger, DataLakeServiceClient dataLakeServiceClient, IConfiguration configuration)
    {
        _logger = logger;
        _dataLakeServiceClient = dataLakeServiceClient;
        _configuration = configuration;
    }

    public async Task<IActionResult> Index()
    {
        List<JsonFile> jsonFiles = new List<JsonFile>();

        var fileSystemClient = _dataLakeServiceClient.GetFileSystemClient(_configuration["BlobContainerName"]);

        await foreach (var path in fileSystemClient.GetPathsAsync("/", true))
        {
            if (path.IsDirectory == false)
            {
                var fileClient = fileSystemClient.GetFileClient(path.Name);
                var fileStream = fileClient.OpenRead();
                var streamReader = new StreamReader(fileStream);
                jsonFiles.Add(new JsonFile
                {
                    Name = path.Name,
                    Content = await streamReader.ReadToEndAsync()
                });

            }
        }

        ViewBag.JsonFiles = jsonFiles;

        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
