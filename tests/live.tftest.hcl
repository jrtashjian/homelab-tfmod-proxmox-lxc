provider "proxmox" {
  insecure = true
}

run "create_nano" {
  command = apply

  variables {
    node_name = "pve-node01"
    name      = "tfmod-test-lxc"
    size      = "nano"
  }

  assert {
    condition     = output.id != ""
    error_message = "id should be set"
  }

  assert {
    condition     = output.name == "tfmod-test-lxc"
    error_message = "name should match"
  }

  assert {
    condition     = output.node_name == "pve-node01"
    error_message = "node_name should match"
  }

  assert {
    condition     = output.ipv4_address != ""
    error_message = "ipv4_address should be set"
  }
}
