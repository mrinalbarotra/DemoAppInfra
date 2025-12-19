variable "mssqldatabases" {
  type = map(object({
    name         = string
    collation    = string #"SQL_Latin1_General_CP1_CI_AS"
    license_type = string #"LicenseIncluded"
    max_size_gb  = number #2
    sku_name     = string #"S0"
    enclave_type = string #"VBS"
  }))

}

variable "server_id" {
  type = string
}

# variable "prevent_destroy" {
#   type = bool
# }

variable "tags" {
  type = map(string)

}
