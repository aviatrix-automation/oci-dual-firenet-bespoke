output "oci_eastwest_firenet" {
  description = "East-West Transit FireNet"
  sensitive   = true
  value       = module.oci_transit_firenet_1
}

output "oci_egress_firenet" {
  description = "Egress Transit FireNet"
  sensitive   = true
  value       = module.oci_transit_firenet_2
}

output "oci_ingress_spoke" {
  description = "Ingress spoke"
  sensitive   = true
  value       = module.oci_ingress_spoke
}

/*output "oci_wl1_spoke" {
  description = "Workload 1 spoke"
  value       = module.oci_workload_spoke_1
}*/