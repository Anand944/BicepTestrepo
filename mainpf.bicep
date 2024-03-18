@description('Tags to be assigned to the resources.')
param tags object 

@description('Username for the Virtual Machine.')
param adminUsername string 

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
//param adminPassword string 

// Generate a unique suffix based on the resource group name and VM name
param publicIpName string // = 'PublicIP-${uniqueString(RgName, vmName)}'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string 

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string 

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
@allowed([
  '2016-datacenter-gensecond'
  '2016-datacenter-server-core-g2'
  '2016-datacenter-server-core-smalldisk-g2'
  '2016-datacenter-smalldisk-g2'
  '2016-datacenter-with-containers-g2'
  '2016-datacenter-zhcn-g2'
  '2019-datacenter-core-g2'
  '2019-datacenter-core-smalldisk-g2'
  '2019-datacenter-core-with-containers-g2'
  '2019-datacenter-core-with-containers-smalldisk-g2'
  '2019-datacenter-gensecond'
  '2019-datacenter-smalldisk-g2'
  '2019-datacenter-with-containers-g2'
  '2019-datacenter-with-containers-smalldisk-g2'
  '2019-datacenter-zhcn-g2'
  '2022-datacenter-azure-edition'
  '2022-datacenter-azure-edition-core'
  '2022-datacenter-azure-edition-core-smalldisk'
  '2022-datacenter-azure-edition-smalldisk'
  '2022-datacenter-core-g2'
  '2022-datacenter-core-smalldisk-g2'
  '2022-datacenter-g2'
  '2022-datacenter-smalldisk-g2'
])
param OSVersion string 


@description('Size of the virtual machine.')
param vmSize string 

@description('Location for all resources.')
param location string 

@description('Name of the virtual machine.')
param vmName string 


@description('Name of the virtual network associated with the virtual machine.')
param virtualNetworkName string 

@description('Name of the subnet within the virtual network where the virtual machine is deployed.')
param  subnetNames array 

@description('Address space for the virtual network.')
param address_space array 

@description('Address prefix for the subnet within the virtual network.')
param subnetPrefix array 

@description('Type of storage account for the disk.')
param storageAccountType string 

@description('Size of the disk in gigabytes.')
param diskSizeGB int 

@description('Logical unit number (LUN) for the disk.')
param lun int 

@description('Option for creating the disk.')
param createOption string 

param subscriptionId string

param kvResourceGroup string

param kvName string

targetScope = 'subscription'

param RgName string 

resource azureResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01'={
  name: RgName
  location: location
}


resource kv 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: kvName
  scope: resourceGroup(subscriptionId, kvResourceGroup )
}

module vm 'Azurevmpoc-vp/modules/Azurevmpoc.bicep'={
  name:'pocvm'
  scope:azureResourceGroup
  params:{
    location: location
    tags: tags
    OSVersion: OSVersion
    adminPassword: kv.getSecret('vmAdminPassword')
    adminUsername: adminUsername
    createOption: createOption
    diskSizeGB: diskSizeGB
    lun: lun
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIpName: publicIpName
    publicIpSku: publicIpSku
    storageAccountType: storageAccountType
    subnetNames:subnetNames
    virtualNetworkName: virtualNetworkName
    vmName:  vmName
    vmSize:  vmSize
  }
}

module vnet 'Azurevmpoc-vp/modules/Azurevnet.bicep'={
  name:'vnetpoc'
  scope:azureResourceGroup
  params:{
    location: location
    tags: tags
    address_space: address_space
    virtualNetworkName: virtualNetworkName
    subnetNames:subnetNames
    subnetPrefix:subnetPrefix
  }
}


