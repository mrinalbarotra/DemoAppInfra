variable "mssqlservers" {
    description = ",map of mssqlservers"
    type = map(object({
      name = string
      resource_group_name= string
      location = string
      version = string
      minimum_tls_version = string
      azuread_administrator = object({
        login_username = string
        ad_group_name = string
      })
    })) 
}


variable "tags" {
    type =map(string)
}