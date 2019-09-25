#configure the azure provider
provider "azurerm" {
    version = "1.34.0"
}

#create resource group
resource "azurerm_resource_group" "terrafrg" {
    name = "myterrtest"
    location = "west US"
}

#Create Virtual Network
resource "azurerm_virtual_network" "terrafnet" {
name = "myvnet"  
address_space = ["10.0.0.0/16"]
location = "${azurerm_resource_group.terrafrg.location}"
resource_group_name = "${azurerm_resource_group.terrafrg.name}"
}

#create subnet
resource "azurerm_subnet" "terrafsub" {
name = "mysub"
resource_group_name = "${azurerm_resource_group.terrafrg.name}"
virtual_network_name = "${azurerm_virtual_network.terrafnet}"
address_prefix = "10.0.1.0./24"  
}

#create network interface
resource "azurerm_network_interface" "terranetin" {
name = "mynic"
resource_group_name = "${azurerm_resource_group.terrafrg.name}"
location = "${azurerm_resource_group.terrafrg.location}"

ip_configuration {
    name = "myipconf"
    subnet_id = "${azurerm_subnet.terrafsub.id}"
    private_ip_address_allocation = "dynamic"
}
}

#create storage account
resource "azurerm_storage_account" "terrastc" {
name = "mystac"
resource_group_name = "${azurerm_resource_group.terrafrg.name}"
location = "${azurerm_resource_group.terrafrg.location}"
account_tier = "standard"
account_replication_type = "LRS"
}

#create VM
resource "azurerm_virtual_machine" "terravm" {
name = "myvm"  
resource_group_name = "${azurerm_resource_group.terrafrg.name}"
location = "${azurerm_resource_group.terrafrg.location}"
network_interface_ids = ["${azurerm_network_interface.terranetin}"]
vm_size = "standard_DS1_v2"

storage_os_disk {
    name = "myosdk"
    create_option = "FromImage"
    caching = "ReadWrite" 
    managed_disk_type = "standard_LRS"   
}
storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "Windowsserver"
    sku = "2016-datacenter"
    version = "latest"}

OS_profile {
    computer_name = "${azurerm_virtual_machine.terravm.name}"
    admin_username = "myadmin"
    password = "Password@123"
}
os_profile_windows_config {

}
}

