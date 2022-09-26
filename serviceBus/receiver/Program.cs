// See https://aka.ms/new-console-template for more information
using System.Reflection.Metadata.Ecma335;
using Azure.Messaging.ServiceBus;

Console.WriteLine("Hello, World!");
var connectionString = "Endpoint=sb://fl-20220907-sbus.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=z1hnqlI1vxjroxg+7ofIICPA8En2i0pUU5yKA+TmzEs=";
var queueName = "fl-20220907-queue";

var client = new ServiceBusClient(connectionString);

var processor = client.CreateProcessor(queueName);

processor.ProcessMessageAsync += async msg =>
{
    Console.WriteLine(msg.Message.Body.ToString());
    await msg.CompleteMessageAsync(msg.Message);
};

processor.ProcessErrorAsync += msgArgs =>
{
    Console.WriteLine(msgArgs.Exception.Message);
    return Task.CompletedTask;
};
await processor.StartProcessingAsync();

Console.ReadKey();

await processor.StopProcessingAsync();
await processor.DisposeAsync();
await client.DisposeAsync();