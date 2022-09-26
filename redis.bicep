var location = 'northeurope'
var systemName = 'fl-webappbicep'

resource redis 'Microsoft.Cache/redis@2021-06-01' = {
  name: '${systemName}-red'
  location: location
  properties: {
    sku: {
      capacity: 0
      family: 'C'
      name: 'Basic'
    }
  }
}
