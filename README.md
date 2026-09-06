# Proxmox LXC Module

Terraform module to create reproducible Debian LXC containers on Proxmox with preset sizes.

## Usage

```hcl
module "lxc" {
  source = "git::git@gitlab.int.jrtashjian.com:homelab/tfmod-proxmox-lxc.git"

  node_name = "pve-node02"
  name      = "my-app"

  size = "medium"

  vlan_id = 66
  bridge  = "vmbr0"

  mount_points = [
    {
      volume = "local-lvm"
      size   = "20G"
      path   = "/mnt/data"
    }
  ]

  ipv4_address       = "192.168.10.50/24"
  ipv4_gateway       = "192.168.10.1"
  ansible_pass       = var.ansible_pass
  ansible_public_key = var.ansible_public_key
}
```

## Available Sizes

### Standard

| Size     | CPU | RAM    | Root Disk |
|----------|-----:|-------:|----------:|
| `nano`   | 1    | 1 GB   | 8 GB      |
| `small`  | 1    | 2 GB   | 8 GB      |
| `medium` | 2    | 4 GB   | 12 GB     |
| `large`  | 4    | 8 GB   | 16 GB     |
| `xlarge` | 6    | 16 GB  | 24 GB     |

### High Memory

| Size             | CPU | RAM    | Root Disk |
|------------------|-----:|-------:|----------:|
| `highmem-medium` | 2    | 24 GB  | 16 GB     |
| `highmem-large`  | 4    | 48 GB  | 24 GB     |

### High CPU (Compute)

| Size             | CPU | RAM    | Root Disk |
|------------------|-----:|-------:|----------:|
| `compute-large`  | 8    | 16 GB  | 16 GB     |
| `compute-xlarge` | 16   | 32 GB  | 24 GB     |

## Variables

| Name                  | Type           | Default      | Description |
|-----------------------|----------------|--------------|-------------|
| `node_name`           | string         | -            | Proxmox node name |
| `name`                | string         | -            | Hostname of the LXC |
| `os_template`         | string         | `"local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"` | OS template file ID |
| `size`                | string         | `"small"`    | Preset size (see tables above) |
| `disk_size`           | number         | `0`          | Root disk size in GB; `0` uses the preset value |
| `mount_points`        | list(object)   | `[]`         | Additional volume mounts |
| `root_datastore_id`   | string         | `"machines"` | Datastore ID for the root disk |
| `bridge`              | string         | `"vmbr0"`    | Network bridge for the primary interface |
| `vlan_id`             | number         | `null`       | VLAN ID for the primary interface; omit for untagged |
| `ipv4_address`        | string         | `"dhcp"`     | IPv4 address with CIDR or `"dhcp"` |
| `ipv4_gateway`        | string         | `null`       | IPv4 gateway (required for static IP) |
| `ansible_pass`        | string         | -            | Root password (sensitive) |
| `ansible_public_key`  | string         | -            | SSH public key for root |
| `tags`                | list(string)   | `[]`         | Additional tags to apply to the LXC |


**Mount point example:**

```hcl
mount_points = [
  { volume = "local-lvm",      size = "10G", path = "/mnt/volume" },
  { volume = "local-lvm:subvol-xxx", size = "50G", path = "/mnt/data" }
]
```

## Testing

Live smoke test against the homelab. Creates a nano LXC, asserts outputs, then destroys it.

```bash
op run --env-file=".env.example" -- terraform test
```

## Requirements

- Proxmox provider `bpg/proxmox` ≥ 0.103.0
