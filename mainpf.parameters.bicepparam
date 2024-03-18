using 'mainpf.bicep'

param tags = {
  App: 'POC'
  Owner: 'Infra-team'
  Confidentiality: 'Sensitive'
  CostCenter: 'Infra-team'
  Env: 'Innovation'
  BusinessImpact: 'Low'
}

param adminUsername = 'adminuser'
//param adminPassword = 'Siddu$$1234anand'
param publicIpName = 'PublicIP-${uniqueString(RgName, vmName)}'
param publicIPAllocationMethod = 'Dynamic'
param publicIpSku = 'Basic'
param OSVersion = '2016-datacenter-smalldisk-g2'
param vmSize = 'Standard_B1ms'
param location = 'eastus'
param vmName = 'testpocvm03'
param virtualNetworkName = 'MyVNET01'
param subnetNames = [ 'Subnet' ]
param address_space = [ '10.0.0.0/16' ]
param subnetPrefix = [ '10.0.0.0/24' ]
param storageAccountType = 'StandardSSD_LRS'
param diskSizeGB = 1023
param lun = 0
param createOption = 'Empty'
param RgName = 'testrg'
param subscriptionId = '7851163e-411d-4fa4-b675-7155cf6d3903'
param kvResourceGroup = 'kvvmrg01'
param kvName = 'kvtestpocvmeastus01'
