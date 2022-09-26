#! /bin/bash
topicEndpoint=$(az eventgrid topic show --name fl-eg-eg -g fl-20220902-eg --query "endpoint" --output tsv)
key=$(az eventgrid topic key list --name fl-eg-eg -g fl-20220902-eg --query "key1" --output tsv)
event='[ {"id": "'"$RANDOM"'", "eventType": "recordInserted", "subject": "myapp/vehicles/motorcycles", "eventTime": "'`date +%Y-%m-%dT%H:%M:%S%z`'", "data":{ "make": "Contoso", "model": "Monster"},"dataVersion": "1.0"} ]'
curl -X POST -H "aeg-sas-key: $key" -d "$event" $topicEndpoint