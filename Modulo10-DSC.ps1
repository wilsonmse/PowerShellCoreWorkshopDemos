#Modulo 10

#SLIDE 23 - DEMO 01 - RESOURCES

#get builtin dsc resource
Get-DscResource

#find dsc resources using find-dscresource
Find-DscResource -ModuleName CommonTasks

#verify if name parameter accepts wildcard
get-help Find-DSCResource -Parameter name

#as find-dscresource's name parameter do not support wildcard, need to filter using where-object
Find-DSCResource | where-object {$_.name -like '*sql*'}








 ## SLIDE 31 - DEMO 02 - LCM
 Get-DscLocalConfigurationManager








 ## SLIDE 41 - DEMO 03 - DSC Requerements

# https://docs.microsoft.com/en-us/powershell/dsc/getting-started/lnxgettingstarted?view=dsc-1.1

<#
Supported Linux operation system versions
The following Linux operating system versions are supported by DSC for Linux.

CentOS 6, 7, and 8 (x64)
Debian GNU/Linux 8, 9, and 10 (x64)
Oracle Linux 6 and 7 (x64)
Red Hat Enterprise Linux Server 6, 7, and 8 (x64)
SUSE Linux Enterprise Server 12 and 15 (x64)
Ubuntu Server 14.04 LTS, 16.04 LTS, 18.04 LTS, and 20.04 LTS (x64)


#>
#SSL Versions
openssl version

# Check if OMI is installed
sudo apt list --installed | grep omi 

# Check if DSC is Installed
sudo apt list --installed | grep dsc

<#
MOFs are in /etc/opt/omi/conf/dsc/configuration

modules live in: ls /opt/microsoft/dsc/modules
zips downloaded to: ls /opt/microsoft/dsc/module_packages

getDscConfiguration is a Python script: /opt/microsoft/dsc/Scripts
#>

sudo /opt/microsoft/dsc/Scripts/GetDscConfiguration.py

sudo /opt/microsoft/dsc/Scripts/StartDscConfiguration.py -configurationmof /tmp/10.0.0.20.mof 










#SLIDE 46 - DEMO 04 - AZURE OVERVIEW





# SLIDE 53 - DEMO 05 - AZURE CLOUD SHELL





# SLIDE 61 - DEMO 06 - AZURE CONNECTION PROCESS
Add-AzAccount

Get-AzSubscription | select-object name, state






# SLIDE 67 - DEMO 07 - AZURE STORAGE BLOB

Set-AzVMDscExtension -ResourceGroupName $resourcegroupname -VMName $vmname -




# SLIDE 76 - DEMO 07 - AZURE PUBLISHING PROCESS
#Step 1: Create Azure Resource Group


$credential = get-credential
$resourcegroupname = "WorkshopPowerShellCore_RG"

$locationobject = Get-AzLocation | select Location, DisplayName, PhysicalLocation, GeographyGroup, Latitude, Longitude | Out-GridView -PassThru
$location = $locationobject.location
$rg = New-AzResourceGroup -Name $resourcegroupname  -Location $location


#Limit the vmname up to 15 characters
$vmname = "workshopdemo02"

#Step 2: Create Azure Storage Account

$stgaccount = New-AzStorageAccount -ResourceGroupName $resourcegroupname -Name stgworkshopdemo20220728b -SkuName  Standard_LRS -Kind StorageV2 -Location $location

$azdiskconfig = new-azdiskconfig -SkuName StandardSSD_LRS -DiskSizeGB 128 -OsType Windows -Location $location -CreateOption Empty 

$vmosdisk = new-azdisk -ResourceGroupName $resourcegroupname -DiskName "OSDSK_$vmname" -Disk $azdiskconfig

#Step 3: Create Azure Network Security Group

#Create network security rule configuration that will be used to create the network security group

$secrule = New-AzNetworkSecurityRuleConfig -Name "AllowRDPAccess" -Description "Allow access to VM using RDP" -Access  Allow `
-Protocol "TCP" -SourcePortRange "*" -SourceAddressPrefix "*" `
-DestinationPortRange "3389" -DestinationAddressPrefix "*" -Direction "Inbound" -Priority 500

#Create network security group using the network security rule configuration

$nsg = New-AzNetworkSecurityGroup -Name "NSG_$vmname" -ResourceGroupName $resourcegroupname -Location $location -SecurityRules $secrule

#Step 4: Create Azure Virtual Network

# Create virtual network subnet virtual configuration that will be used to create the virtual network

$subnet_name = 'subnet_workshopdemo'
$subnet_addressPrefix = '10.0.0.0/24'
$subnetconfig = New-AzVirtualNetworkSubnetConfig -Name subnet_workshopdemo -AddressPrefix $subnet_addressPrefix -WarningAction SilentlyContinue

# Create Azure Virtual network using the virtual network subnet configuration

$vnet_name = 'vnet_workshopdemo'
$vnet_addressPrefix = '10.0.0.0/16'
$vnet = New-AzVirtualNetwork -Name $vnet_name -ResourceGroupName ($resourcegroupname) -Location $location -AddressPrefix $vnet_addressPrefix -Subnet $subnetconfig

$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet | where-object {$_.name -eq $subnet_name}

# Step 6: Create Azure Public Address

$PIPName = "PIP_$vmname"

$PIP = New-AzPublicIpAddress -Name $PIPName -ResourceGroupName ($resourcegroupname) -Location $location -AllocationMethod Dynamic


# Step 7: Create Network Interface Card

$NetAdapterName = "NIC_$vmname"

$nic = New-AzNetworkInterface -Name $NetAdapterName -ResourceGroupName ($resourcegroupname) `
 -Location $location -SubnetId $subnet.id -PublicIpAddressId $pip.Id `
 -NetworkSecurityGroupId $nsg.id

# Step 8: Get Virtual Machine publisher, Image Offer, Sku and Image

Get-AzVMImagePublisher -location eastus  | where-object {$_.PublisherName -like '*Microsoft*'} | select-object PublisherName, location 
$Publisher = Get-AzVMImagePublisher -location eastus  | where-object {$_.PublisherName -eq 'MicrosoftWindowsServer'}  
#$Publisher = Get-AzVMImagePublisher -location eastus  | Out-GridView -PassThru
Get-AzVMImageOffer -publishername $Publisher.PublisherName -Location $location
$vmimageoffer = Get-AzVMImageOffer -publishername $Publisher.PublisherName -Location $location | where-object {$_.Offer -eq 'WindowsServer'}
Get-AzVMImageSku -Location $location -PublisherName ($Publisher.PublisherName) -Offer ($vmimageoffer.Offer)
$vmimagesku = Get-AzVMImageSku -Location $location -PublisherName ($Publisher.PublisherName) -Offer ($vmimageoffer.Offer) | where-object {$_.skus -eq '2022-datacenter'}
Get-AzVMImage -Location $location -PublisherName ($publisher.PublisherName) -Offer ($vmimageoffer.Offer) -sku ($vmimagesku.Skus) 
$vmimage = Get-AzVMImage -Location $location -PublisherName ($publisher.PublisherName) -Offer ($vmimageoffer.Offer) -sku ($vmimagesku.Skus) | sort-object version -Descending | select-object -First 1

# Step 9: Create a virtual machine configuration file
#This command creates a configurable local virtual machine object for Azure. Store the results as a variable.

$vmsize = Get-AzVMSize -Location eastus | Out-GridView  -PassThru | Sort-Object Name
$vmsizename = $vmsize.name

$VM = New-AzVMConfig -VMSize ($vmsize.name) -VMName $vmname

$VM = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName $vmname -Credential $credential -ProvisionVMAgent -EnableAutoUpdate
$VM = Set-AzVMSourceImage -VM $vm -PublisherName ($Publisher.PublisherName) -Offer $vmimageoffer.Offer -Skus $vmimagesku.skus -Version $vmimage.Version
$VM = Add-AzVMNetworkInterface -VM $vm -Id $nic.Id
$vm = Set-AzVMOSDisk -vm $vm -name $vmosdisk -CreateOption fromImage 

$VM = Set-AzVMBootDiagnostic -vm $vm -Enable -ResourceGroupName $resourcegroupname -StorageAccountName $stgaccount.StorageAccountName

#Step 10: Create Azure Virtual Machine

#This cmdlet creates the virtual machine once all the previous requirements are complete. The –VM parameter accepts the virtual machine configuration that is stored in a variable

New-AzVM -ResourceGroupName $resourcegroupname -Location $location -VM $vm










# SLIDE 89 AZURE PUBLISHING VM
get-help Publish-AzVMDscConfiguration
Get-Command Publish-AzVMDscConfiguration -Syntax 

#Generate Access Keys
#new-AzStorageAccountKey -ResourceGroupName $resourcegroupname -Name $stgaccount.StorageAccountName -KeyName key1
$stgaccountkeys = get-AzStorageAccountKey -ResourceGroupName $resourcegroupname -Name $stgaccount.StorageAccountName
$accesskey = $stgaccountkeys[0].Value

$Params = @{
    ConfigurationPath        = '.\iisinstall.ps1'
    ConfigurationArchivePath = '.\iisinstall.ps1.zip'
    Force                    = $true
    Verbose                  = $true 
}
Publish-AzVMDscConfiguration @Params

$DSCConfiguration = @{
    ConfigurationPath = '.\iisinstall.ps1.zip' 
    StorageAccountName = $stgaccount.StorageAccountName
    ResourceGroupName = $resourcegroupname
    Force             = $true
    Verbose           = $true
}

Publish-AzVMDscConfiguration @DSCConfiguration

Get-AzVMExtensionImage -Location $location -publishername Microsoft.Powershell -Type dsc

# Apply configuration
$DSCExtension = @{
    # ConfigurationArgument: supported types for values include: 
    #            primitive types, string, array and PSCredential
    #ConfigurationArgument = @{ComputerName = 'localhost'}
    ConfigurationName     = 'iisinstall'
    ConfigurationArchive  = 'iisinstall.ps1.zip'
    Force                 = $True
    Verbose               = $True
    location              = $location
    ResourceGroupName     = $resourcegroupname
    VMName                = $vmname
    ArchiveStorageAccountName = $stgaccount.StorageAccountName
    version               = "2.9"
} 

Set-AzVMDSCExtension @DSCExtension
