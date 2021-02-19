[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

#Initial Setup
    $config = ConvertFrom-Json $configuration;

    #Instance URL
    $baseURI = "https://api.bamboohr.com/api/gateway.php/$($config.companySubDomain)";

    #Authorization
    $headers = @{};
    $headers["Authorization"] = "Basic $([System.Convert]::ToBase64String( [System.Text.Encoding]::ASCII.GetBytes("$($config.apiKey):x") );)";
    $headers["Accept"] = "application/json";

    #Functions
    function Get-ObjectProperties
    {
        param ($Object, $Depth = 0, $MaxDepth = 10)
        $OutObject = @{};

        foreach($prop in $Object.PSObject.properties)
        {
            if($prop.Name -in @("ExternalId","DisplayName","Contracts")) { continue; }
            if ($prop.TypeNameOfValue -eq "System.Management.Automation.PSCustomObject" -or $prop.TypeNameOfValue -eq "System.Object" -and $Depth -lt $MaxDepth -and $prop.Value -ne $null)
            {
                $OutObject[$prop.Name] = Get-ObjectProperties -Object $prop.Value -Depth ($Depth + 1);
            }
            else
            {
                $OutObject[$prop.Name] = "$($prop.Value)";
            }
        }
        return $OutObject;
    }

#Get All Employees
$parameters = @{
                    Headers = $headers;
                    Method = 'GET'
                    Uri = "$($baseURI)/v1/employees/directory"
}
Write-Information "Fetching Employees [$($parameters.Uri)]";
$persons = Invoke-RestMethod @parameters
Write-Information "Completed Employees Request";

#Get All Employee Jobs
$parameters = @{
                    Headers = $headers;
                    Method = 'GET'
                    Uri = "$($baseURI)/v1/employees/all/tables/jobInfo"
}
Write-Information "Fetching Employee Jobs [$($parameters.Uri)]";
$jobs = Invoke-RestMethod @parameters
Write-Information "Completed Employee Jobs Request";


Write-Information "Processing Employees";
foreach($p in $persons.employees)
{

    $parameters = @{
                        Headers = $headers;
                        Method = 'GET'
                        Uri = "$($baseURI)/v1/employees/$($p.id)"
                        Body = @{
                                    fields = $config.employeeFields
                                }
    }
    Write-Information "Fetching Employee Data [$($parameters.Uri)]";
    $employee = Invoke-RestMethod @parameters
    $person = @{};
    $person = Get-ObjectProperties $employee
    
    $person['ExternalId'] = $p.id;
    $person['DisplayName'] = "$($p.firstName) $($p.lastName) - $($person['ExternalId'])";
    
    $person['Contracts'] = [System.Collections.ArrayList]@();

    foreach($job in $jobs)
    {
        if($job.employeeId -eq  $p.id)
        {
            $contract = {};
            $contract = Get-ObjectProperties $job
            $contract['ExternalId'] = $job.id;
            $contract['terminationDate'] = $employee.terminationDate;
            $contract['hireDate'] = $employee.hireDate;
            $contract['originalHireDate'] = $employee.originalHireDate;

            [void]$person.Contracts.Add($contract);
        }
    }

    Write-Output ($person | ConvertTo-Json -Depth 10);
}

Write-Information "Finished Processing Employees";
Write-Verbose -Verbose "Person import completed";