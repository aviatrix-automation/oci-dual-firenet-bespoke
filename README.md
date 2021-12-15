# OCI Dual FireNet Bespoke

## **_Updated mid-Dec to reflect HPE spokes attached to Transit FireNet (6.5)_**

##  Advanced **_customized_** example demonstrating the use of multiple Transit FireNet and an Ingress Spoke

- Built with https://registry.terraform.io/modules/terraform-aviatrix-modules/oci-transit-firenet/aviatrix/latest
- Drive it by variables as needed
- Set TF_VARs for username, controller_ip, password in your env
- This repository is customized **_specifically for OCI us-phoenix-1_** deployment

  
## Enhancements 12-15-2021
- removed ```aviatrix_controller_config``` per request
- added ```insane_mode = true``` for HPE
- removed local module reference for OCI spokes using https://registry.terraform.io/modules/terraform-aviatrix-modules/oci-spoke/aviatrix/latest instead
- removed S2C connections
- updated README


## Enhancements 7-21-2021

- Added ``bgp_ecmp=true`` on ew transit firenet
- Added ```excluded_advertised_spoke_routes = module.oci_ingress_spoke.vcn.private_subnets[1].cidr``` on ew transit firenet
- Added two Site-to-Cloud external connections to ew transit firenet ```aviatrix_transit_external_device_conn```
- Added ```keep_alive_via_lan_interface_enabled = true``` 
  
### Infrastructure diagram

<img src="img/oci-dual-transit-firenet-example-no-workload.png" height="400">

### Compatibility
Terraform version | Controller version | Terraform provider version
:--- | :--- | :---
0.13,0.14,0.15 | 6.5.2721 | 2.20.3
0.13,0.14,0.15 | 6.4.2672 | 2.19.3
0.13,0.14,0.15 | 6.4.2776 | 2.19.5

### Variables

The variables are defined in ```terraform.tfvars```.

**Note:** 

Runtime - ~1h, monitor through OCI Console & Aviatrix Controller

```ha_enabled = false``` controls whether ha is built gateways and firewall instances - this is set to false by default to minimize provisioning time for MVP

```instance_size``` controls the size of all the transit spokes and gateways. 

```firewall_size``` controls the size of the PAN instances

```insane_mode``` controls whether insane mode encryption (HPE) is enabled in transit and spokes

### Prerequisites

- Software version requirements met
- Aviatrix Controller with Access Account in OCI
- Sufficient limits in place for OCI region in scope **_(Compute quotas, etc.)_**
- terraform .13 in the user environment ```terraform -v``` 

### Workflow

- Modify ```terraform.tfvars``` _(i.e. access account name, regions, cidrs, etc.)_ and save the file.
- ```terraform init```
- ```terraform plan```
- ```terraform apply --auto-approve```

### Addressed an issue identified June 22 to add ```egress_enabled=true```

For this issue:

```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place
Terraform will perform the following actions:
  # module.oci_transit_firenet_2.aviatrix_firenet.firenet will be updated in-place
  ~ resource "aviatrix_firenet" "firenet" {
      ~ egress_enabled                       = true -> false
        id                                   = "avx-us-oci-tfa-egr-firenet"
      ~ keep_alive_via_lan_interface_enabled = true -> false
        # (6 unchanged attributes hidden)
    }
```

- Added variable for egress_enabled so it is passed through to the egress firenet resource

<img src="img/dual-firenet-advanced-view.png">


### Terraform state (post-provisioning)

```
$ terraform state list
aviatrix_spoke_transit_attachment.egress_attach_wl1
aviatrix_spoke_transit_attachment.ew_attach_wl1
aviatrix_spoke_transit_attachment.ingress_attach
module.oci_ingress_spoke.aviatrix_spoke_gateway.default
module.oci_ingress_spoke.aviatrix_vpc.default
module.oci_transit_firenet_1.aviatrix_firenet.firenet
module.oci_transit_firenet_1.aviatrix_firewall_instance.firewall_instance_1[0]
module.oci_transit_firenet_1.aviatrix_firewall_instance.firewall_instance_2[0]
module.oci_transit_firenet_1.aviatrix_firewall_instance_association.firenet_instance1[0]
module.oci_transit_firenet_1.aviatrix_firewall_instance_association.firenet_instance2[0]
module.oci_transit_firenet_1.aviatrix_transit_gateway.default
module.oci_transit_firenet_1.aviatrix_vpc.default
module.oci_transit_firenet_2.aviatrix_firenet.firenet
module.oci_transit_firenet_2.aviatrix_firewall_instance.firewall_instance_1[0]
module.oci_transit_firenet_2.aviatrix_firewall_instance.firewall_instance_2[0]
module.oci_transit_firenet_2.aviatrix_firewall_instance_association.firenet_instance1[0]
module.oci_transit_firenet_2.aviatrix_firewall_instance_association.firenet_instance2[0]
module.oci_transit_firenet_2.aviatrix_transit_gateway.default
module.oci_transit_firenet_2.aviatrix_vpc.default
module.oci_workload_spoke_1.aviatrix_spoke_gateway.default
module.oci_workload_spoke_1.aviatrix_vpc.default
```

