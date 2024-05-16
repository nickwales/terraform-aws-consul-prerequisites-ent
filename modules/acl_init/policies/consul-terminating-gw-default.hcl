service_prefix "" {
  policy = "read"
}
node_prefix "" {
  policy = "read"
}

// service "<terminating gateway>" {
//   policy = "write"
// }

// service "<external service 1>" {
//   policy = "write"
// }

// service "<external service ...n>" {
//   policy = "write"
// }

# Alternatively, enforce naming patterns
service_prefix "external-" {
  policy = "write"
}