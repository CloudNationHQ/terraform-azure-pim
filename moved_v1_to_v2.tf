moved {
  from = azurerm_pim_active_role_assignment.main
  to   = azurerm_pim_active_role_assignment.this
}

moved {
  from = azurerm_pim_eligible_role_assignment.main
  to   = azurerm_pim_eligible_role_assignment.this
}

moved {
  from = azurerm_role_management_policy.main
  to   = azurerm_role_management_policy.this
}
