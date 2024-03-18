@description('Tags to be assigned to the resources.')
param tags object ={
  App             :'POC'
  Owner           :'Infra-team'
  Confidentiality :'Sensitive'
  CostCenter      : 'Infra-team'
  Env             :'Innovation'
  BusinessImpact  : 'Low'
}

@description('Username for the Virtual Machine.')
param adminUsername string = 'adminuser'

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string 

// Generate a unique suffix based on the resource group name and VM name
param publicIpName string = 'PublicIP-${uniqueString(RgName, vmName)}'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Dynamic'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

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
param OSVersion string = '2016-datacenter-smalldisk-g2'


@description('Size of the virtual machine.')
param vmSize string = 'Standard_B1ms'

@description('Location for all resources.')
param location string = 'eastus2'

@description('Name of the virtual machine.')
param vmName string = 'testpocvm0'


@description('Name of the virtual network associated with the virtual machine.')
param virtualNetworkName string = 'MyVNET'

@description('Name of the subnet within the virtual network where the virtual machine is deployed.')
param  subnetNames array = ['Subnet']

@description('Address space for the virtual network.')
param address_space array = ['10.0.0.0/16']

@description('Address prefix for the subnet within the virtual network.')
param subnetPrefix array = ['10.0.0.0/24']

@description('Type of storage account for the disk.')
param storageAccountType string = 'StandardSSD_LRS'

@description('Size of the disk in gigabytes.')
param diskSizeGB int = 1023

@description('Logical unit number (LUN) for the disk.')
param lun int = 0

@description('Option for creating the disk.')
param createOption string = 'Empty'

targetScope = 'subscription'

param RgName string = 'testrg'

resource azureResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01'={
  name: RgName
  location: location
}
module vm 'Azurevmpoc-vp/modules/Azurevmpoc.bicep'={
  name:'pocvm'
  scope:azureResourceGroup
  params:{
    location: location
    tags: tags
    OSVersion: OSVersion
    adminPassword: adminPassword
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


