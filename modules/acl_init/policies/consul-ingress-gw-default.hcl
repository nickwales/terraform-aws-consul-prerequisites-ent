service_prefix "" {
  policy = "read"
}
node_prefix "" {
  policy = "read"
}

service "ingress-gateway" {
  policy = "write"
}

# Optional, but used during envoy bootstrapping to discover the gRPC port if it's not running on 8502
# Can also be scoped to the individual agent, but you then need a unique token per agent or per gateway instance
agent_prefix "" {
  policy = "read"
}