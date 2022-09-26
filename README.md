Messing around with bicep

## Deploy
```
az group create -n fl-20220613-bicepplay --location northeurope --tags Owner=Frans Environment=Experiment
az deployment group create --resource-group fl-20220613-bicepplay --template-file main.bicep 
```

## References
- Import: https://zimmergren.net/generate-bicep-templates-from-existing-azure-resources-vscode/
- Reference existing (for "shared"): https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/existing-resource
- Shared config/global variables: https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/patterns-shared-variable-file