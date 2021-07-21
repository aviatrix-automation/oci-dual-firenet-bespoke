# Phase Native Ingress infrastructure

F5s, VNICs, PAN, NLB, ALB, load balancer backends

## Summary

Using the state from Aviatrix provisioning, provision native OCI infrastructure into the ingress spoke.


### 02-oci-native state post-provisioning
```
$ terraform state list
data.oci_identity_availability_domains.availability_domains
data.oci_identity_fault_domains.fault_domains
data.terraform_remote_state.infra
oci_core_instance.f5_instance_1
oci_core_instance.f5_instance_2
oci_core_instance.palo_fw_1
oci_core_instance.palo_fw_2
oci_core_nat_gateway.avx-ingress-nat
oci_core_vnic_attachment.f5_instance_1_vnic2
oci_core_vnic_attachment.f5_instance_1_vnic3
oci_core_vnic_attachment.f5_instance_2_vnic2
oci_core_vnic_attachment.f5_instance_2_vnic3
oci_load_balancer_backend.http_backend_1
oci_load_balancer_backend.http_backend_2
oci_load_balancer_backend.https_backend_1
oci_load_balancer_backend.https_backend_2
oci_load_balancer_backend_set.http_backend_set
oci_load_balancer_backend_set.https_backend_set
oci_load_balancer_listener.http_listener
oci_load_balancer_listener.https_listener
oci_load_balancer_load_balancer.alb
oci_network_load_balancer_network_load_balancer.f5_ext_nlb01
oci_network_load_balancer_network_load_balancer.f5_ext_nlb02
```

### To inspect any of the state for indexes from Phase I in ```../oci-dual-firenet-bespoke```

Issue a command similar to this to code additional infrastructure

```
$ terraform state show module.oci_ingress_spoke.aviatrix_vpc.default
# module.oci_ingress_spoke.aviatrix_vpc.default:
resource "aviatrix_vpc" "default" {
    account_name              = "TM-OCI"
    aviatrix_firenet_vpc      = false
    aviatrix_transit_vpc      = false
    cidr                      = "10.55.76.0/22"
    cloud_type                = 16
    enable_native_gwlb        = false
    enable_private_oob_subnet = false
    id                        = "avx-ingress-spoke"
    name                      = "avx-ingress-spoke"
    private_subnets           = [
        {
            cidr      = "10.55.76.192/26"
            name      = "avx-ingress-spoke-private-subnet-3"
            subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaa3nae727q65o4b5g3vvzulirjdmp2jyv6lb766fu2tqg5zb5unnyq"
        },
        {
            cidr      = "10.55.76.128/26"
            name      = "avx-ingress-spoke-private-subnet-2"
            subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaaibcbdpdbkdarbvfeoshr56ebvzh7d4ttey4o3ughwxrztl5hwg7a"
        },
        {
            cidr      = "10.55.76.64/26"
            name      = "avx-ingress-spoke-private-subnet-1"
            subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaaxmooonjtjkjlgpxf3g4745iaedlct2t7omi4zdc2iymj37vbprja"
        },
    ]
    public_subnets            = [
        {
            cidr      = "10.55.76.0/26"
            name      = "avx-ingress-spoke-public-subnet"
            subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaa7ybmyybrfr7cdx3fetl6vva5jjukypj3ctntnbjeotxlvssdwnsq"
        },
    ]
    region                    = "us-phoenix-1"
    route_tables              = []
    vpc_id                    = "ocid1.vcn.oc1.phx.amaaaaaamjkdzoqacd5kahuz5wg2pc7bndiuyanioco62yi6be5m5nz3xyuq"

    subnets {
        cidr      = "10.55.76.192/26"
        name      = "avx-ingress-spoke-private-subnet-3"
        subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaa3nae727q65o4b5g3vvzulirjdmp2jyv6lb766fu2tqg5zb5unnyq"
    }
    subnets {
        cidr      = "10.55.76.128/26"
        name      = "avx-ingress-spoke-private-subnet-2"
        subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaaibcbdpdbkdarbvfeoshr56ebvzh7d4ttey4o3ughwxrztl5hwg7a"
    }
    subnets {
        cidr      = "10.55.76.64/26"
        name      = "avx-ingress-spoke-private-subnet-1"
        subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaaxmooonjtjkjlgpxf3g4745iaedlct2t7omi4zdc2iymj37vbprja"
    }
    subnets {
        cidr      = "10.55.76.0/26"
        name      = "avx-ingress-spoke-public-subnet"
        subnet_id = "ocid1.subnet.oc1.phx.aaaaaaaa7ybmyybrfr7cdx3fetl6vva5jjukypj3ctntnbjeotxlvssdwnsq"
    }
}
```