# Make sure you are connected otherwise run 
Add-AzAccount

#check context
Get-AzContext | format-table Name, Environment

# Create an Azure Resource Group
New-AzResourceGroup -Name "Global-Azure-2020-Demo" -Location "westeurope"

# Check if the RG  has been created
Get-AzResourceGroup | format-table ResourceGroupName, Location, ProvisioningState

# explore the API versions
# https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-07-01/virtualmachines

$resourcegroup = "Global-Azure-2020-Demo"

#DEMO 1: Deploy a single resource
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-1" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\StorageAccount.json" `
        -TemplateParameterFile ".\templates\StorageAccount.parameters.json" `
        -Verbose

    # check if created
    Get-AzStorageAccount

    # Pass a parameter as an argument, ugly but works :)
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-1" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\StorageAccount.json" `
        -storageAccountType "Standard_GRS" `
        -Verbose
    
    # Override parameter file by passing a parameter as an argument
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-1" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\StorageAccount.json" `
        -TemplateParameterFile ".\templates\StorageAccount.parameters.json" `
        -storageAccountType "Standard_LRS" `
        -Verbose

        # pass parameter like a hastable
        $params=@{} 
        $key='StorageAccountType'
        $value='Standard_LRS'
        $params.Add($key,$value)

    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-1" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\StorageAccount.json" `
        @params `
        -Verbose 

# DEMO 2: Incremental vs. Complete deployment model
    # Go through vnet1subnet.json
    # Create a Vnet with 1 subnet
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-2" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\vnet1subnet.json" `
        -TemplateParameterFile ".\templates\vnet1subnets.parameters.json" `
        -Verbose


    # Go through vnet2subnets.json
    # Run another template with the same Vnet name with but adding a 2nd subnet
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-2" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\vnet2subnets.json" `
        -TemplateParameterFile ".\templates\vnet2subnets.parameters.json" `
        -Verbose


    #check the resources created till now
    Get-AzResource -ResourceGroupName $resourcegroup | Format-Table -AutoSize

    # Run the *same* template but in Complete mode
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-2" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\vnet2subnets.json" `
        -TemplateParameterFile ".\templates\vnet2subnets.parameters.json" `
        -Mode Complete `
        -Verbose

    #check the resources now, after the Complete mode
    Get-AzResource -ResourceGroupName $resourcegroup | Format-Table -AutoSize

        
# DEMO 3: Deploy a simple Windows VM
    # Go through SimpleWindowsVM.json
    Write-Host "Supply password for the admin user of the VM:"
    $password = Read-Host -AsSecureString
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-3" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\SimpleWindowsVM.json" `
        -TemplateParameterFile ".\templates\SimpleWindowsVM.parameters.json" `
        -AdminPassword $password `
        -Verbose

# DEMO 4: Deploy a PaaS service a Web App
    New-AzResourceGroupDeployment `
        -DeploymentName "GlobalAzureGreece2020-Demo-4" `
        -ResourceGroupName $resourcegroup `
        -TemplateFile ".\templates\webApp.json" `
        -TemplateParameterFile ".\templates\webApp.parameters.json" `
        -Verbose


    ## URI location of ARM Template
    New-AzResourceGroupDeployment `
        -ResourceGroupName myresourcegroup `
        -TemplateUri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json"