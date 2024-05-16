# only supported in the default partition, where peering-via-mesh-gateway control traffic originates/terminates
partition_prefix "" {
  peering = "read"
}

namespace_prefix "" {
  service_prefix "" {
    policy = "read"
  }
  node_prefix "" {
    policy = "read"
  }
}

// namespace "<mesh gateway namespace>" {
//   service "<mesh gateway service>" {
//     policy = "write"
//   }
// }