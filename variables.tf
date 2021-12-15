variable "username" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = ""
}

variable "controller_ip" {
  type    = string
  default = ""
}

variable "oci_account_name" {
  description = "The OCI account name from Aviatrix Controller"
  type        = string
  default     = ""
}

variable "azure_account_name" {
  description = "The Azure account name from Aviatrix Controller"
  type        = string
  default     = ""
}

variable "oci_region" {
  description = "The OCI region for deployment"
  type        = string
  default     = "us-ashburn-1"
}

variable "ha_enabled" {
  description = "Flag to enable Aviatrix HA"
  type        = bool
  default     = false
}

variable "ew_transit_name" {
  description = "Applies name to VCN and Transit gateways"
  type        = string
  default     = ""
}

variable "ew_transit_cidr" {
  type    = string
  default = ""
}

variable "egress_transit_name" {
  description = "Applies name to VCN and Transit gateways"
  type        = string
  default     = ""
}

variable "egress_transit_cidr" {
  type    = string
  default = ""
}

variable "ingress_spoke_name" {
  description = "Applies name to VCN and Spoke gateways"
  type        = string
  default     = ""
}

variable "ingress_spoke_cidr" {
  type    = string
  default = ""
}

variable "workload_spoke_1_name" {
  description = "Applies name to VCN and Spoke gateways"
  type        = string
  default     = ""
}

variable "workload_spoke_1_cidr" {
  type    = string
  default = ""
}

variable "workload_spoke_2_name" {
  description = "Applies name to VCN and Spoke gateways"
  type        = string
  default     = ""
}

variable "workload_spoke_2_cidr" {
  type    = string
  default = ""
}

variable "insane_mode" {
  type    = bool
  default = false
}
variable "firewall_image" {}

variable "firewall_image_version" {} # i.e. 9.1.3, 9.1.6, 10.0.4

variable "firewall_size" {} # i.e. VM.Standard2.4, VM.Standard2.8