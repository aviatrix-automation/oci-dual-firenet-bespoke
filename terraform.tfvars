oci_region             = "us-phoenix-1"
oci_account_name       = "TM-OCI"   # Replace this with the OCI access account name in controller
azure_account_name     = "TM-Azure" # Replace this with the Azure access account name in controller
ha_enabled             = true
insane_mode            = true
firewall_image         = "Palo Alto Networks VM-Series Next Generation Firewall"
firewall_image_version = "9.1.6"
firewall_size          = "VM.Standard2.8"
ew_transit_name        = "eastwest"
ew_transit_cidr        = "10.55.68.0/22" #"10.10.0.0/16"
egress_transit_name    = "egress"
egress_transit_cidr    = "10.55.72.0/22" #"10.20.0.0/16"
ingress_spoke_name     = "ingress"
ingress_spoke_cidr     = "10.55.76.0/22" #"10.30.0.0/16"
// If you want to add workload spokes
workload_spoke_1_name = "workload-1"
workload_spoke_1_cidr = "10.10.0.0/16"
