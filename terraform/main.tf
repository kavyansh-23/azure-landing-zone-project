# Management Group & Policy Assignment
resource "azurerm_management_group" "platform" {
  display_name = "Platform-MG"
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  management_group_id  = azurerm_management_group.platform.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  parameters           = <<PARAMETERS
{
  "listOfAllowedLocations": {
    "value": ["westeurope", "northeurope"]
  }
}
PARAMETERS
}

# Hub and Spoke Networking
resource "azurerm_resource_group" "network_rg" {
  name     = "network-hub-spoke-rg"
  location = "westeurope"
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "spoke" {
  name                = "spoke-vnet"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.1.0.0/16"]
}

# Entra ID Group (Azure AD)
resource "azuread_group" "aks_admins" {
  display_name     = "AKS-Cluster-Admins"
  security_enabled = true
}