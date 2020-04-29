
    #-------------------------------------------------------------
    #------- SOME BASIC PowerShell commands with Az cmdlet ------- 
    #-------------------------------------------------------------

    # Get the context and a list of contexts available
    Get-AzContext 
    Get-AzContext -ListAvailable
    
    # Add an Azure Account to the PowerShell environment
    Connect-AzAccount

    # Check the modules installed
    Get-Module Az -ListAvailable
    # and find latest version
    Find-Module Az

    # if you have an older version than the latest
    Update-Module Az

    # if Az Module is not installed get it from the Gallery
    # may need elevation for installation
    Install-Module Az -AllowClobber -Repository "PSGallery"

    # Switch between contexts
    Set-AzContext -SubscriptionName "Free Trial"

    # Get information about the subscriptions you have in your tenant
    Get-AzSubscription 

    # Get help for a command
    Get-Help Stop-AzVm 
    
    # Get help for a command with examples
    Get-Help New-AzVM -Examples

    # get a list of the Get-AzVM cmdlet
    Get-AzVM | Get-Member

    # Get a list of available VM sizes
    Get-AzVMSize -Location $location | Where-Object Name -Like "*F2*s*"

    # Get the availale VM Images for the specific pubisher
    # Publisher: Who created the image i.e. MicrosoftWindowsServer    
    Get-AzVMImagePublisher -Location $location | Where-Object {$_.PublisherName -like "Microsoft*Server*"}
    $publisher="MicrosoftWindowsServer"
    # Offer: A group of related images i.e. WindowsServer
    Get-AzVMImageOffer -Location $location -PublisherName $publisher
    # SKU: a specific build of the Offer i.e. 2019-Datacenter
    $offer="WindowsServer"
    Get-AzVMImageSku -Location $location -PublisherName $publisher -Offer $offer
    # Version: the vesrion number of a specific SKU i.e. use -latest to get latest version
    Get-AzVMImage -Location $location -PublisherName $publisher -Offer $offer -Skus "2019-Datacenter"
    
    #---------------------------------------------------------
    #------- SOME INFORMATION ABOUT RESOURCE PROVIDERS ------- 
    #---------------------------------------------------------

    # View all Azure locations
    Get-AzLocation | Format-Table Location, DisplayName -AutoSize

    # variable to hold the location for the rest of examples
    $location = "westeurope"
 
    # List the resource providers that are registered
    # feautes are rolled out sometimes in some regions first and then to the rest, so this way you can check
    Get-AzResourceProvider -Location $location | Format-Table ProviderNamespace, ResourceTypes -AutoSize
    
    # List all that are available 
    Get-AzResourceProvider -Location $location -ListAvailable | Format-Table ProviderNamespace, ResourceTypes -AutoSize
    
    # Count the ones that are not registered the unregistered ones can be manually registered 
    # OR depending the resource can be implicitly registered while deploying the resource
    Get-AzResourceProvider -Location $location -ListAvailable | Where-Object {$_.RegistrationState -eq 'NotRegistered'} | Measure-Object
    
    # Get more information on a specific resource provider
    (Get-AzResourceProvider -ProviderNamespace Microsoft.Compute).ResourceTypes.ResourceTypeName 

    # Actions available for a specific type of resource within the provider
    # Based on action we can create a custom RBAC role if we want to
    Get-AzResourceProviderAction -OperationSearchString "Microsoft.Compute/disks/*" | Format-Table Operation, Description -AutoSize
    
    # Check the API versions available
    # Used in order not to break compatibility with new version and functionality
    ((Get-AzResourceProvider -ProviderNamespace Microsoft.Compute).ResourceTypes | Where-Object ResourceTypeName -EQ virtualMachines).ApiVersions

    