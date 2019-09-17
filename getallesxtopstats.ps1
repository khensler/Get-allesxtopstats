Function Get-EsxtopAPI {
    param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)
    ]
    [VMware.VimAutomation.ViCore.Impl.V1.Inventory.InventoryItemImpl]$VMHost
    )

    $serviceManager = Get-View ($global:DefaultVIServer.ExtensionData.Content.serviceManager) -property "" -ErrorAction SilentlyContinue

    $locationString = "vmware.host." + $VMHost.Name
    $services = $serviceManager.QueryServiceList($null,$locationString)
    foreach ($service in $services) {
        if($service.serviceName -eq "Esxtop") {
            $serviceView = Get-View $services.Service -Property "entity"
            $serviceView.ExecuteSimpleCommand("CounterInfo")
            break
        }
    }
}


Function Get-EsxtopAPIstat {
    param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)
    ]
    [VMware.VimAutomation.ViCore.Impl.V1.Inventory.InventoryItemImpl]$VMHost
    )

    $serviceManager = Get-View ($global:DefaultVIServer.ExtensionData.Content.serviceManager) -property "" -ErrorAction SilentlyContinue

    $locationString = "vmware.host." + $VMHost.Name
    $services = $serviceManager.QueryServiceList($null,$locationString)
    foreach ($service in $services) {
        if($service.serviceName -eq "Esxtop") {
            $serviceView = Get-View $services.Service -Property "entity"
            $serviceView.ExecuteSimpleCommand("FetchStats")
            $serviceView.ExecuteSimpleCommand("FreeStats")
            break
        }
    }
}

$vmhosts = get-vmhost

foreach ($vmhost in $vmhosts){
$defpath = ".\"+$vmhost.name+"def.txt"
$statpath = ".\"+$vmhost.name+"stat.txt"
$vmhost | get-esxtopapi | out-file -filepath $defpath-encoding ASCII
$vmhost | get-esxtopapistat | out-file -filepath $statpath -encoding ASCII
}
