// See https://aka.ms/new-console-template for more information
using Azure.Messaging.ServiceBus;

Console.WriteLine("Hello, World!");
var connectionString = "Endpoint=sb://fl-20220907-sbus.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=z1hnqlI1vxjroxg+7ofIICPA8En2i0pUU5yKA+TmzEs=";
var queueName = "fl-20220907-queue";

var client = new ServiceBusClient(connectionString);
var sender = client.CreateSender(queueName);

using var messageBatch = await sender.CreateMessageBatchAsync();

Enumerable.Range(1, 3).ToList().ForEach(i => messageBatch.TryAddMessage(new ServiceBusMessage($"Message {i} {DateTime.UtcNow}")));

await sender.SendMessagesAsync(messageBatch);

await sender.DisposeAsync();
await client.DisposeAsync();