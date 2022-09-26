using Microsoft.VisualBasic;
using StackExchange.Redis;
using System.Diagnostics.CodeAnalysis;
using System.Security;
using System.Threading.Tasks;

const string connectionString = "fl-webappbicep-red.redis.cache.windows.net:6380,password=S3e3N3pQNda0yakofFrnrhQxQ2GAkdhoKAzCaO6Kfhk=,ssl=True,abortConnect=False";

using var cache = ConnectionMultiplexer.Connect(connectionString);

var db = cache.GetDatabase();
var result = await db.ExecuteAsync("ping");
Console.WriteLine($"PING = {result.Type} : {result}");
const string key = "test:key";
var setValue = await db.StringSetAsync(key, "100");

var getValue = await db.StringGetAsync(key);
Console.WriteLine(getValue);

var result2 = await db.ExecuteAsync("flushdb");
Console.WriteLine($"flushdb = {result2.Type} : {result2}");

var getValue2 = await db.StringGetAsync(key);
Console.WriteLine(getValue2);


// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");
