terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.101.0"
    }
  }
}

locals {
  presets = {
    # Standard configurations.
    nano   = { cpu = 1, memory = 1024, disk = 8 }
    small  = { cpu = 1, memory = 2048, disk = 8 }
    medium = { cpu = 2, memory = 4096, disk = 12 }
    large  = { cpu = 4, memory = 8192, disk = 16 }
    xlarge = { cpu = 6, memory = 16384, disk = 24 }

    # High Memory configurations.
    highmem-medium = { cpu = 2, memory = 24576, disk = 16 }
    highmem-large  = { cpu = 4, memory = 49152, disk = 24 }

    # High CPU configurations.
    compute-large  = { cpu = 8, memory = 16384, disk = 16 }
    compute-xlarge = { cpu = 16, memory = 32768, disk = 24 }
  }

  # Use override if provided, otherwise preset
  effective_disk = var.disk_size > 0 ? var.disk_size : local.presets[var.size].disk
}

resource "proxmox_virtual_environment_container" "base_lxc" {
  node_name = var.node_name
  tags      = ["terraform"]

  cpu {
    cores = local.presets[var.size].cpu
  }

  memory {
    dedicated = local.presets[var.size].memory
  }

  disk {
    datastore_id = "machines"
    size         = local.effective_disk
  }

  dynamic "mount_point" {
    for_each = var.mount_points

    content {
      volume = mount_point.value.volume
      size   = mount_point.value.size
      path   = mount_point.value.path
      backup = true
    }
  }

  network_interface {
    name     = "eth0"
    firewall = true
  }

  initialization {
    hostname = var.lxc_name

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    user_account {
      password = var.ansible_pass
      keys     = [var.ansible_public_key]
    }
  }

  features {
    nesting = true
  }

  unprivileged = true

  operating_system {
    type             = "debian"
    template_file_id = proxmox_virtual_environment_file.debian_container_template.id
  }

  depends_on = [proxmox_virtual_environment_file.debian_container_template]

  lifecycle {
    ignore_changes = [description]
  }
}

resource "proxmox_virtual_environment_file" "debian_container_template" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.node_name

  source_file {
    path = "http://download.proxmox.com/images/system/debian-13-standard_13.1-2_amd64.tar.zst"
  }
}
