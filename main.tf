# OCI Dual Transit Firenet Custom with sgm config

# Create an Aviatrix Controller Config
resource "aviatrix_controller_config" "sgm_config" {
  sg_management_account_name = var.azure_account_name
  http_access                = true
  enable_vpc_dns_server      = true
  security_group_management  = true
}

# East-West
module "oci_transit_firenet_1" {
  source                           = "./terraform-aviatrix-oci-transit-firenet"
  name                             = var.ew_transit_name
  cidr                             = var.ew_transit_cidr
  region                           = var.oci_region
  account                          = var.oci_account_name
  firewall_image_version           = var.firewall_image_version
  fw_instance_size                 = var.firewall_size
  ha_gw                            = var.ha_enabled
  insane_mode                      = var.insane_mode
  excluded_advertised_spoke_routes = module.oci_ingress_spoke.vcn.private_subnets[1].cidr
  bgp_ecmp                         = true
  depends_on = [
    aviatrix_controller_config.sgm_config
  ]
}

# Egress
module "oci_transit_firenet_2" {
  source                        = "./terraform-aviatrix-oci-transit-firenet"
  name                          = var.egress_transit_name
  cidr                          = var.egress_transit_cidr
  region                        = var.oci_region
  account                       = var.oci_account_name
  firewall_image_version        = var.firewall_image_version
  fw_instance_size              = var.firewall_size
  ha_gw                         = var.ha_enabled
  enable_egress_transit_firenet = true
  egress_enabled                = true
  inspection_enabled            = false
  connected_transit             = false
  insane_mode                   = var.insane_mode
  depends_on = [
    aviatrix_controller_config.sgm_config
  ]
}

# Ingress
module "oci_ingress_spoke" {
  source      = "./terraform-aviatrix-oci-spoke"
  name        = var.ingress_spoke_name
  cidr        = var.ingress_spoke_cidr
  region      = var.oci_region
  account     = var.oci_account_name
  ha_gw       = var.ha_enabled
  insane_mode = false
  depends_on = [
    aviatrix_controller_config.sgm_config
  ]
}

resource "aviatrix_spoke_transit_attachment" "ingress_attach" {
  spoke_gw_name   = module.oci_ingress_spoke.spoke_gateway.gw_name
  transit_gw_name = module.oci_transit_firenet_1.transit_gateway.gw_name
}

# Create an Aviatrix Transit External Device Connection 
resource "aviatrix_transit_external_device_conn" "ew_firenet_chicago1" {
  vpc_id             = module.oci_transit_firenet_1.vcn.name
  connection_name    = "CHI1-S2C-ew-ext-conn"
  gw_name            = module.oci_transit_firenet_1.transit_gateway.gw_name
  connection_type    = "bgp"
  bgp_local_as_num   = "65458"
  bgp_remote_as_num  = "65274"
  ha_enabled         = false
  remote_gateway_ip  = "10.55.65.130" # aviatrix_site2cloud.chicago1.remote_gateway_ip
  local_tunnel_cidr  = "10.55.57.1/30, 10.55.57.5/30"
  remote_tunnel_cidr = "10.55.57.2/30, 10.55.57.6/30"
}

# Create an Aviatrix Transit External Device Connection 
resource "aviatrix_transit_external_device_conn" "ew_firenet_chicago2" {
  vpc_id             = module.oci_transit_firenet_1.vcn.name
  connection_name    = "CHI2-S2C-ew-ext-conn"
  gw_name            = module.oci_transit_firenet_1.transit_gateway.gw_name
  connection_type    = "bgp"
  bgp_local_as_num   = "65458"
  bgp_remote_as_num  = "65274"
  ha_enabled         = false
  remote_gateway_ip  = "10.55.65.134"
  local_tunnel_cidr  = "10.55.57.9/30, 10.55.57.13/30"
  remote_tunnel_cidr = "10.55.57.10/30, 10.55.57.14/30"
  prepend_as_path = [
    "65458",
    "65458",
    "65458",
    "65458"
  ]
}

// Sample workload spoke
/*
# WL 1
module "oci_workload_spoke_1" {
  source      = "./terraform-aviatrix-oci-spoke"
  name        = var.workload_spoke_1_name
  cidr        = var.workload_spoke_1_cidr
  region      = var.oci_region
  account     = var.oci_account_name
  ha_gw       = var.ha_enabled
  attached    = false
  insane_mode = false
  depends_on = [
    aviatrix_controller_config.sgm_config
  ]
}

// Attach to both firenet transit

resource "aviatrix_spoke_transit_attachment" "ew_attach_wl1" {
  spoke_gw_name   = module.oci_workload_spoke_1.spoke_gateway.gw_name
  transit_gw_name = module.oci_transit_firenet_1.transit_gateway.gw_name
  depends_on      = [module.oci_transit_firenet_1, module.oci_transit_firenet_2]
}

resource "aviatrix_spoke_transit_attachment" "egress_attach_wl1" {
  spoke_gw_name   = module.oci_workload_spoke_1.spoke_gateway.gw_name
  transit_gw_name = module.oci_transit_firenet_2.transit_gateway.gw_name
  depends_on      = [module.oci_transit_firenet_1, module.oci_transit_firenet_2]
}*/

