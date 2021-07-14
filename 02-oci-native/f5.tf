
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
    subnet_id = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[0].subnet_id
  }
  instance_id  = oci_core_instance.f5_instance_1.id
  display_name = "${oci_core_instance.f5_instance_1.display_name}-vnic2"
}

### Attach VNIC3 of F5 instance 1 ############
resource "oci_core_vnic_attachment" "f5_instance_1_vnic3" {
  create_vnic_details {
    subnet_id = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.public_subnets[0].subnet_id
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
    subnet_id = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.private_subnets[0].subnet_id
  }
  instance_id  = oci_core_instance.f5_instance_2.id
  display_name = "${oci_core_instance.f5_instance_2.display_name}-vnic2"
}

### Attach VNIC3 of F5 instance 2 ############
resource "oci_core_vnic_attachment" "f5_instance_2_vnic3" {
  create_vnic_details {
    subnet_id = data.terraform_remote_state.infra.outputs.oci_ingress_spoke.vcn.public_subnets[0].subnet_id
  }
  instance_id  = oci_core_instance.f5_instance_2.id
  display_name = "${oci_core_instance.f5_instance_2.display_name}-vnic3"
}