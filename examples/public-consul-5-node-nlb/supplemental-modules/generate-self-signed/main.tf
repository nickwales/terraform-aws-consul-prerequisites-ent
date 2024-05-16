resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create a CA cert with the private key you just generated.
resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name = "ca.${var.shared_san}"
  }

  validity_period_hours = 720 # 30 days

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]

  is_ca_certificate = true
}

# Generate another private key. This one will be used
# To create the certs on your Vault nodes
resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name = "*.${var.shared_san}"
  }

  dns_names = [
    var.shared_san,
    "localhost",
    "*.server.dc1.consul",
    "server.dc1.consul"
  ]

  ip_addresses = [
    "127.0.0.1",
  ]
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 720 # 30 days

  allowed_uses = [
    "client_auth",
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]
}

resource "local_file" "ca" {
  content  = tls_self_signed_cert.ca.cert_pem
  filename = "../../consul-agent-ca.pem"
}

resource "local_file" "private_key" {
  content  = nonsensitive(tls_private_key.server.private_key_pem)
  filename = "../../consul-server-private.pem"
}

resource "local_file" "pub_key_no_root" {
  content  = tls_locally_signed_cert.server.cert_pem
  filename = "../../consul-server-public.pem"
}
