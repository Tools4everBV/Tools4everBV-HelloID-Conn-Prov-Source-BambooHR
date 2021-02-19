[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

#Initial Setup
    $config = ConvertFrom-Json $configuration;

    #Instance URL
    $baseURI = "https://api.bamboohr.com/api/gateway.php/$($config.companySubDomain)";

    #Authorization
    $headers = @{};
    $headers["Authorization"] = "Basic $([System.Convert]::ToBase64String( [System.Text.Encoding]::ASCII.GetBytes("$($config.apiKey):x") );)";
    $headers["Accept"] = "application/json";

#Get Departments from Field Details
$parameters = @{
                    Headers = $headers;
                    Method = 'GET'
                    Uri = "$($baseURI)/v1/meta/lists/"
}
Write-Information "Fetching Departments [$($parameters.Uri)]";
$data = Invoke-RestMethod @parameters
$departments = ($data | Where-Object { $_.name -eq "Department" }).options;
Write-Information "Completed Departments Request";

Write-Information "Processing Departments";
foreach($d in $departments)
{

    $department = @{
                    ExternalId=$d.name;
                    DisplayName=$d.name;
                    Name=$d.name;
                    ManagerExternalId="";
                    ParentExternalId="";
    };
    
    Write-Output ($department | ConvertTo-Json -Depth 10);
}
Write-Information "Finished Processing Departments";
Write-Verbose -Verbose "Department import completed";