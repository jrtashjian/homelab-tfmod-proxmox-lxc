variable "node_name" {
  description = "The name of the node to create the LXC on"
  type        = string
}

variable "name" {
  description = "The name of the LXC to create"
  type        = string
}

variable "os_template" {
  description = "The OS template file ID to create the LXC from"
  type        = string
  default     = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
}

variable "size" {
  description = "The size of the LXC (nano, small, medium, large, xlarge, highmem-medium, highmem-large, compute-large, compute-xlarge)"
  type        = string
  default     = "small"

  validation {
    condition     = contains(["nano", "small", "medium", "large", "xlarge", "highmem-medium", "highmem-large", "compute-large", "compute-xlarge"], var.size)
    error_message = "Size must be one of: nano, small, medium, large, xlarge, highmem-medium, highmem-large, compute-large, compute-xlarge"
  }
}

variable "disk_size" {
  description = "Root disk size in GB. Defaults to preset value."
  type        = number
  default     = 0 # 0 = use preset
}

variable "mount_points" {
  description = "List of additional mount points to create in the LXC"
  type = list(object({
    volume = string
    size   = string
    path   = string
  }))
  default = []
}

variable "root_datastore_id" {
  description = "The datastore ID for the root disk"
  type        = string
  default     = "machines"
}

variable "bridge" {
  description = "Network bridge for the primary interface"
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN ID for the primary interface. Null means untagged."
  type        = number
  default     = null
}

variable "ipv4_address" {
  description = "The IPv4 address to assign to the LXC"
  type        = string
  default     = "dhcp"
}

variable "ipv4_gateway" {
  description = "The IPv4 gateway to assign to the LXC"
  type        = string
  default     = null
}

variable "ansible_pass" {
  description = "Ansible password"
  type        = string
  sensitive   = true
}

variable "ansible_public_key" {
  description = "Ansible public key"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the LXC"
  type        = list(string)
  default     = []
}
