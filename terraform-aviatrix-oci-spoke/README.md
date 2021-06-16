# Terraform Aviatrix OCI Spoke

### Description
This module deploys a VCN, an Aviatrix spoke gateway, and attaches it to an Aviatrix Transit gateway. Defining the Aviatrix Terraform provider is assumed upstream and is not part of this module.

### It was copied locally to this example repo from TF registry to support dual firenet

The following variables are required:

key | value
--- | ---
name | avx-\<name\>-spoke
region | OCI region to deploy the spoke VCN and gateway
account | The OCI account name on the Aviatrix controller, under which the controller will deploy this VCN
cidr | The IP CIDR wo be used to create the VCN
transit_gw | The name of the Aviatrix Transit gateway to attach the spoke

The following variables are optional:

key | default | value
--- | --- | ---
instance_size | VM.Standard2.2 | Size of the spoke gateway instances
ha_gw | true | Builds spoke gateways with HA by default
active_mesh | true | Set to false to disable active_mesh
prefix | true | Boolean to enable prefix name with avx-
suffix | true | Boolean to enable suffix name with -spoke
attached | true | Set to false if you don't want to attach spoke to transit.
security_domain | | Provide security domain name to which spoke needs to be deployed. Transit gateway must be attached and have segmentation enabled.
single_az_ha | true | Set to false if Controller managed Gateway HA is desired
single_ip_snat | false | Specify whether to enable Source NAT feature in single_ip mode on the gateway or not. Please disable AWS NAT instance before enabling this feature. Currently only supports AWS(1) and AZURE(8)
customized_spoke_vpc_routes | | A list of comma separated CIDRs to be customized for the spoke VPC routes. When configured, it will replace all learned routes in VPC routing tables, including RFC1918 and non-RFC1918 CIDRs. Example: 10.0.0.0/116,10.2.0.0/16
filtered_spoke_vpc_routes | | A list of comma separated CIDRs to be filtered from the spoke VPC route table. When configured, filtering CIDR(s) or it’s subnet will be deleted from VPC routing tables as well as from spoke gateway’s routing table. Example: 10.2.0.0/116,10.3.0.0/16
included_advertised_spoke_routes | | A list of comma separated CIDRs to be advertised to on-prem as Included CIDR List. When configured, it will replace all advertised routes from this VPC. Example: 10.4.0.0/116,10.5.0.0/16

Outputs
This module will return the following objects:

key | description
--- | ---
vcn | The created vcn as an object with all of it's attributes. This was created using the aviatrix_vpc resource.
spoke_gateway | The created Aviatrix spoke gateway as an object with all of it's attributes.

