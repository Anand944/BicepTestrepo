
param subnetName string
param subnetPrefix string
param virtualNetworkName string

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  name: '${virtualNetworkName}/${subnetName}'
  properties: {
    addressPrefix: subnetPrefix
  }

}

output subnet_id string = subnet.id




