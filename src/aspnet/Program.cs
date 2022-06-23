using Azure.Core;
using Azure.Identity;
using Azure.Storage;
using Azure.Storage.Files.DataLake;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

if (bool.Parse(builder.Configuration["UseManagedIdentity"]))
{
  TokenCredential tokenCredential = new DefaultAzureCredential(new DefaultAzureCredentialOptions
  {
    ManagedIdentityClientId = builder.Configuration["ManagedIdentityClientId"]
  });

  builder.Services.AddSingleton(new DataLakeServiceClient(
    new Uri($"https://{builder.Configuration["StorageAccountName"]}.dfs.core.windows.net"),
    tokenCredential));
}
else
{
  StorageSharedKeyCredential sharedKeyCredential = new StorageSharedKeyCredential(
    builder.Configuration["StorageAccountName"],
    builder.Configuration["StorageAccountAccessKey"]);

  builder.Services.AddSingleton(new DataLakeServiceClient(
    new Uri($"https://{builder.Configuration["StorageAccountName"]}.dfs.core.windows.net"),
    sharedKeyCredential));
}

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
  app.UseExceptionHandler("/Home/Error");
  // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
  app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
