
# Aviatrix State (Phase I infrastructure provisioning)
data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../../oci-dual-firenet-bespoke/terraform.tfstate"
  }
}

####################################################################################################################
# Resource to get the list of Availabilty Domains
####################################################################################################################
data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

####################################################################################################################
# Resource to get the list of Fault Domains
####################################################################################################################
data "oci_identity_fault_domains" "fault_domains" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0]["name"]
  compartment_id      = var.compartment_ocid
}

#######################################
##### Fake F5s
#######################################

// F5 1
resource "oci_core_instance" "f5_instance_1" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0]["name"]
  fault_domain        = data.oci_identity_fault_domains.fault_domains.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid

  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "false"
    subnet_id                 = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[2].subnet_id
  }

  display_name         = var.F5_instance_1_name
  preserve_boot_volume = "false"
  state                = "RUNNING"
  shape                = var.F5_compute_shape
  source_details {
    source_id   = var.F5_image_ocid # Fake F5 image ocid
    source_type = "image"
  }
  agent_config {
    is_monitoring_disabled = "false"
  }

  lifecycle {
    ignore_changes = [
      create_vnic_details,
      metadata,
      # freeform_tags["timestamp"],
    ]
  }
}

### Attach VNIC2 of F5 instance 1 ############
resource "oci_core_vnic_attachment" "f5_instance_1_vnic2" {
  create_vnic_details {
    subnet_id    = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[0].subnet_id
    display_name = "${oci_core_instance.f5_instance_1.display_name}-vnic2"
  }
  instance_id  = oci_core_instance.f5_instance_1.id
  display_name = "${oci_core_instance.f5_instance_1.display_name}-vnic2"
}

### Attach VNIC3 of F5 instance 1 ############
resource "oci_core_vnic_attachment" "f5_instance_1_vnic3" {
  create_vnic_details {
    subnet_id    = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.public_subnets[0].subnet_id
    display_name = "${oci_core_instance.f5_instance_1.display_name}-vnic3"
  }
  instance_id  = oci_core_instance.f5_instance_1.id
  display_name = "${oci_core_instance.f5_instance_1.display_name}-vnic3"
}

// F5 2
resource "oci_core_instance" "f5_instance_2" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[1]["name"]
  fault_domain        = data.oci_identity_fault_domains.fault_domains.fault_domains[1]["name"]
  compartment_id      = var.compartment_ocid

  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "false"
    subnet_id                 = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[2].subnet_id
  }

  display_name         = var.F5_instance_2_name
  preserve_boot_volume = "false"
  state                = "RUNNING"
  shape                = var.F5_compute_shape
  source_details {
    source_id   = var.F5_image_ocid # Fake F5 image ocid
    source_type = "image"
  }
  agent_config {
    is_monitoring_disabled = "false"
  }

  lifecycle {
    ignore_changes = [
      create_vnic_details,
      metadata,
      # freeform_tags["timestamp"],
    ]
  }
}

### Attach VNIC2 of F5 instance 2 ############
resource "oci_core_vnic_attachment" "f5_instance_2_vnic2" {
  create_vnic_details {
    subnet_id    = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[0].subnet_id
    display_name = "${oci_core_instance.f5_instance_2.display_name}-vnic2"
  }
  instance_id  = oci_core_instance.f5_instance_2.id
  display_name = "${oci_core_instance.f5_instance_2.display_name}-vnic2"
}

### Attach VNIC3 of F5 instance 2 ############
resource "oci_core_vnic_attachment" "f5_instance_2_vnic3" {
  create_vnic_details {
    subnet_id    = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.public_subnets[0].subnet_id
    display_name = "${oci_core_instance.f5_instance_2.display_name}-vnic3"
  }
  instance_id  = oci_core_instance.f5_instance_2.id
  display_name = "${oci_core_instance.f5_instance_2.display_name}-vnic3"
}

### Ingress NAT GW
resource oci_core_nat_gateway avx-ingress-nat {
  block_traffic  = "false"
  compartment_id = var.compartment_ocid
  display_name   = "avx-ingress-nat-gw"
  vcn_id         = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.vpc_id
}


### Palo Firewalls Ingress

 // PAN 1
resource "oci_core_instance" "palo_fw_1" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0]["name"]
  fault_domain        = data.oci_identity_fault_domains.fault_domains.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
 
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "false"
    subnet_id                 = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[2].subnet_id
  }
 
  display_name         = "ingress-pan-9-fw1"
  preserve_boot_volume = "false"
  state                = "RUNNING"
  shape                = var.F5_compute_shape
  source_details {
    source_id   = "ocid1.image.oc1..aaaaaaaaeiv65tqh2bsdyp3f7vmp7ronerpvym7yqtnzkehotuw5hqu3vihq"
    source_type = "image"
  }
  agent_config {
    is_monitoring_disabled = "false"
  }

  lifecycle {
    ignore_changes = [
      create_vnic_details,
      metadata,
      # freeform_tags["timestamp"],
    ]
  }
 
}

// PAN 2
resource "oci_core_instance" "palo_fw_2" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[1]["name"]
  fault_domain        = data.oci_identity_fault_domains.fault_domains.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
 
  create_vnic_details {
    assign_private_dns_record = "true"
    assign_public_ip          = "false"
    subnet_id                 = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[2].subnet_id
  }
 
  display_name         = "ingress-pan-9-fw2"
  preserve_boot_volume = "false"
  state                = "RUNNING"
  shape                = var.F5_compute_shape
  source_details {
    source_id   = "ocid1.image.oc1..aaaaaaaaeiv65tqh2bsdyp3f7vmp7ronerpvym7yqtnzkehotuw5hqu3vihq"
    source_type = "image"
  }
  agent_config {
    is_monitoring_disabled = "false"
  }

  lifecycle {
    ignore_changes = [
      create_vnic_details,
      metadata,
      # freeform_tags["timestamp"],
    ]
  }
 
}

# Load Balancers

### F5 Public NLBs
// F5 NLB 1
resource "oci_network_load_balancer_network_load_balancer" "f5_ext_nlb01" {
  compartment_id = var.compartment_ocid
  display_name                   = "ingress-f5-ext-nlb01"
  subnet_id                      = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.public_subnets[0].subnet_id
  is_preserve_source_destination = "true"
  is_private                     = "false"
}

// F5 NLB 2
resource "oci_network_load_balancer_network_load_balancer" "f5_ext_nlb02" {
  compartment_id = var.compartment_ocid
  display_name                   = "ingress-f5-ext-nlb02"
  subnet_id                      = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.public_subnets[0].subnet_id
  is_preserve_source_destination = "true"
  is_private                     = "false"
}

### F5 Public ALB
// F5 ALB 1
resource "oci_load_balancer_load_balancer" "alb" {
  compartment_id = var.compartment_ocid
  display_name   = "ingress-f5-ext-alb01"
  shape = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = "1500"
    minimum_bandwidth_in_mbps = "150"
  }
  subnet_ids     = [data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.public_subnets[0].subnet_id]
  ip_mode        = "IPV4"
  is_private     = "false"
 
  lifecycle {
    ignore_changes = [
      freeform_tags["timestamp"],
    ]
  }
}


// Backend Set https
resource "oci_load_balancer_backend_set" "https_backend_set" {
  health_checker {
    protocol          = "TCP"
    interval_ms       = "10000"
    port              = "443"
    retries           = "3"
    timeout_in_millis = "3000"
    url_path         =  "/"
  }
  load_balancer_id = oci_load_balancer_load_balancer.alb.id
  name             = "ingress-f5-ext-alb01-bs-https" 
  policy           = "ROUND_ROBIN"
  depends_on = [oci_load_balancer_load_balancer.alb]
  }
  
  ### https backends
  // F5 https backend 1
  resource "oci_load_balancer_backend" "https_backend_1" {
  backendset_name  = oci_load_balancer_backend_set.https_backend_set.name
  ip_address       = oci_core_instance.f5_instance_1.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.alb.id
  port             = "443"
  weight           = "1"
  depends_on = [oci_load_balancer_load_balancer.alb]
}

// F5 https backend 2
  resource "oci_load_balancer_backend" "https_backend_2" {
  backendset_name  = oci_load_balancer_backend_set.https_backend_set.name
  ip_address       = oci_core_instance.f5_instance_2.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.alb.id
  port             = "443"
  weight           = "1"
  depends_on = [oci_load_balancer_load_balancer.alb]
}

// https listener
resource "oci_load_balancer_listener" "https_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.https_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.alb.id
  name                     = "ingress-f5-ext-alb01-https-listener" 
  port                     = "443"
  protocol                 = "TCP"
  connection_configuration {
    idle_timeout_in_seconds = "300"
  }
  depends_on = [
    oci_load_balancer_backend_set.https_backend_set,
    oci_load_balancer_load_balancer.alb
  ]
  }

// Backend Set http
resource "oci_load_balancer_backend_set" "http_backend_set" {
  health_checker {
    protocol          = "HTTP"
    interval_ms       = "10000"
    port              = "80"
    retries           = "3"
    timeout_in_millis = "3000"
    url_path         =  "/"
  }
  load_balancer_id = oci_load_balancer_load_balancer.alb.id
  name             = "ingress-f5-ext-alb01-bs-http" 
  policy           = "ROUND_ROBIN"
  depends_on = [oci_load_balancer_load_balancer.alb]
  }
  
  ### http backends
  // F5 http backend 1
  resource "oci_load_balancer_backend" "http_backend_1" {
  backendset_name  = oci_load_balancer_backend_set.http_backend_set.name
  ip_address       = oci_core_instance.f5_instance_1.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.alb.id
  port             = "80"
  weight           = "1"
  depends_on = [oci_load_balancer_load_balancer.alb]
}

// F5 http backend 2
  resource "oci_load_balancer_backend" "http_backend_2" {
  backendset_name  = oci_load_balancer_backend_set.http_backend_set.name
  ip_address       = oci_core_instance.f5_instance_2.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.alb.id
  port             = "80"
  weight           = "1"
  depends_on = [oci_load_balancer_load_balancer.alb]
}

// http listener
resource "oci_load_balancer_listener" "http_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.http_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.alb.id
  name                     = "ingress-f5-ext-alb01-http-listener" 
  port                     = "80"
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "300"
  }
  depends_on = [
    oci_load_balancer_backend_set.http_backend_set,
    oci_load_balancer_load_balancer.alb
  ]

  }
  
  /*
  // redirect rule
  resource "oci_load_balancer_rule_set" "http2https_rule_set" {
  items {
    action = "REDIRECT"

        redirect_uri {

        host     = "{host}"
        path     = "/"
        port     = "443"
        protocol = "HTTPS"
     }
    response_code    = "301"
  }
  load_balancer_id = oci_load_balancer_load_balancer.alb.id
  name             = "ingress-f5-ext-alb01-http-listener-HTTPRedirecttoHTTPS" 
  depends_on = [
    oci_load_balancer_backend_set.https_backend_set,
    oci_load_balancer_load_balancer.alb
  ]  
}*/

