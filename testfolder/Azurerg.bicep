@description('specifies the location for resources')
param location string = 'eastus'

targetScope = 'subscription'

resource azureResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01'={
  name:'test-rg'
  location: location
}



