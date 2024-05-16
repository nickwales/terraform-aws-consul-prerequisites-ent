# Required to read and snapshot ACL data
acl = "write"
# Allow the snapshot agent to create the key consul-snapshot/lock which will
# serve as a leader election lock when multiple snapshot agents are running in
# an environment

key "consul-snapshot/lock" {
  policy = "write"
}

# Allow the snapshot agent to create sessions on the specified node
session_prefix "ip-" {
  policy = "write"
}

# Allow the snapshot agent to register itself into the catalog
service "consul-snapshot" {
  policy = "write"
}