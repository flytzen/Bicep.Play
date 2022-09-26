var location = 'northeurope'
var systemName = 'fl-20220907'

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: '${systemName}-sbus'
  location: location

  resource queue 'queues@2021-11-01' = {
    name: '${systemName}-queue'
  }
}
