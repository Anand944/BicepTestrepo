param location string = 'Eastus'
param CosmoSQLAccountName string = 'cosmosdbeastus001'
param sqldbname string = 'FlightTests'
param cosmocontainer01 string = 'testcontainer'
var cosmosDBContainerPartitionKey = '/droneId'
resource CosmoSQLAccount 'Microsoft.DocumentDB/databaseAccounts@2023-09-15'={
  name: CosmoSQLAccountName
  location: location
  properties:{
    databaseAccountOfferType: 'Standard'
    locations:[
      {
        locationName: location
      }
    ]
  }
}
resource cosmoSQLdb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-09-15'={
  name:sqldbname
  location:location
  parent: CosmoSQLAccount
  properties:{
    resource: {
      id:  sqldbname
    }
    options: {
      
    }

}
resource cosmoSQLcontainer 'containers'={
  name: cosmocontainer01
  location:location
  properties:{
    resource: {
      id: cosmocontainer01
      partitionKey:{
        kind:'Hash'
        paths:[
           cosmosDBContainerPartitionKey 
        ]
      }

    }

  }
}

}
