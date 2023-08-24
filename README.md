# bicep-vmwithkv
This bicep deploys simply one VM whose Admin Password is stored in Azure Key Vault.

# How to deploy
Open this repository in Visual Studio Code. Then right-click on `main-kvincluded.bicep` or `getStart.bicep` and select [Deploy Bicep File].
![](/imgs/deploy.png)

The difference between these bicep files is just place where Azure Key Vault is created. Out put is completely same. Just for PoC process.

# Notes
If you deploy this bicep file with Azure CLI/PowerShell, it causes validation error. I'm not sure about this reason but all I can say is bicep is based on the thought like that.
This theme is discussed as issue [#10562](https://github.com/Azure/bicep/issues/10562).