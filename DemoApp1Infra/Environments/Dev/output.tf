output "public_ip_ids" {
  value = {
    for k, v in module.pip :
    k => v.public_ip_id
  }
}