<#
    .SYNOPSIS
    Get the IP addresses of VMSS instances
    .PARAMETER VmssName
    The name of the VMSS
    .PARAMETER ResourceGroupName
    The resource group of the VMSS
    .NOTES
     Author: Ryan Nemeth - Ryan@geekyryan.com
     Site: http://www.geekyryan.com
    .LINK
     http://www.geekyryan.com
    .DESCRIPTION
     Version 1.0
    .EXAMPLE
     Get-VmssInstanceIpAddress.ps1 -VmssName my-vmss -ResourceGroupName myResourceGroup
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [String]$VmssName,
    [Parameter(Mandatory=$True)]
    [String]$ResourceGroupName
)

$instances = Get-AzVmssVM -ResourceGroupName $ResourceGroupName -VMScaleSetName $VmssName
$ssNicName = ($instances[0].NetworkProfile.NetworkInterfaces[0].Id).Split('/')[-1]


foreach ($instance in $instances)
{
    $resourceName = $vmssName + "/" + $instance.InstanceId + "/" + $ssNicName
    $target = Get-AzResource -ResourceGroupName $ResourceGroupName -ResourceType Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces -ResourceName $resourceName -ApiVersion 2017-12-01
    Write-Host $instance.Name $target.Properties.ipConfigurations[0].properties.privateIPAddress -ForegroundColor Green
}