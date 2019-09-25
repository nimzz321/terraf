#configure the Azure Provider
provider "azurerm" {
    version = "1.34.0"
  }

#create a resource group
resource "azurerm_resource_goup" "test" {
    name = "production"
    location = "west US"
}

#create a virtual network within the resource group
resource "azurerm_virtual_network" "test" {
name = "production-network"
resource_group_name = "${azurerm_resource_goup.test.name}"
location = "${azurerm_resource_goup.test.location}"
address_space = ["10.0.0.0/16"]  
}
