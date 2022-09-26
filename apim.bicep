var location = 'northeurope'
var systemName = 'fl-apim'

resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: '${systemName}-apim'
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: 'flytzen@neworbit.co.uk'
    publisherName: 'NewOrbit'
  }
}
