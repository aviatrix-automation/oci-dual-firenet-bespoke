# OCI Dual Transit Firenet 

# East-West
module "oci_transit_firenet_1" {
  source                           = "./terraform-aviatrix-oci-transit-firenet"
  name                             = var.ew_transit_name
  cidr                             = var.ew_transit_cidr
  region                           = var.oci_region
  account                          = var.oci_account_name
  firewall_image                   = var.firewall_image
  firewall_image_version           = var.firewall_image_version
  fw_instance_size                 = var.firewall_size
  ha_gw                            = var.ha_enabled
  insane_mode                      = var.insane_mode
  excluded_advertised_spoke_routes = module.oci_ingress_spoke.vcn.private_subnets[1].cidr
  bgp_ecmp                         = true
}

# Egress
module "oci_transit_firenet_2" {
  source                        = "./terraform-aviatrix-oci-transit-firenet"
  name                          = var.egress_transit_name
  cidr                          = var.egress_transit_cidr
  region                        = var.oci_region
  account                       = var.oci_account_name
  firewall_image                = var.firewall_image
  firewall_image_version        = var.firewall_image_version
  fw_instance_size              = var.firewall_size
  ha_gw                         = var.ha_enabled
  enable_egress_transit_firenet = true
  egress_enabled                = true
  inspection_enabled            = false
  connected_transit             = false
  insane_mode                   = var.insane_mode
}

# Ingress
module "oci_ingress_spoke" {
  source      = "terraform-aviatrix-modules/oci-spoke/aviatrix"
  version     = "4.0.6"
  name        = var.ingress_spoke_name
  cidr        = var.ingress_spoke_cidr
  region      = var.oci_region
  account     = var.oci_account_name
  ha_gw       = var.ha_enabled
  attached    = false
  insane_mode = true
}

// Sample workload spoke
# WL 1
module "oci_workload_spoke_1" {
  source      = "terraform-aviatrix-modules/oci-spoke/aviatrix"
  version     = "4.0.6"
  name        = var.workload_spoke_1_name
  cidr        = var.workload_spoke_1_cidr
  region      = var.oci_region
  account     = var.oci_account_name
  ha_gw       = var.ha_enabled
  attached    = false
  insane_mode = true
}

resource "aviatrix_spoke_transit_attachment" "ingress_attach" {
  spoke_gw_name   = module.oci_ingress_spoke.spoke_gateway.gw_name
  transit_gw_name = module.oci_transit_firenet_1.transit_gateway.gw_name
}

resource "aviatrix_spoke_transit_attachment" "ew_attach_wl1" {
  spoke_gw_name   = module.oci_workload_spoke_1.spoke_gateway.gw_name
  transit_gw_name = module.oci_transit_firenet_1.transit_gateway.gw_name
  depends_on      = [module.oci_transit_firenet_1, module.oci_transit_firenet_2]
}

resource "aviatrix_spoke_transit_attachment" "egress_attach_wl1" {
  spoke_gw_name   = module.oci_workload_spoke_1.spoke_gateway.gw_name
  transit_gw_name = module.oci_transit_firenet_2.transit_gateway.gw_name
  depends_on      = [module.oci_transit_firenet_1, module.oci_transit_firenet_2]
}