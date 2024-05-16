output "ca" {
  value       = local_file.ca.filename
  description = "CA certificate that signed the SSL certs"
}

output "private" {
  value       = local_file.private_key.filename
  description = "Private key file for the Vault nodes"
}

output "public" {
  value       = local_file.pub_key_no_root.filename
  description = "Public key file for the Vault nodes"
}