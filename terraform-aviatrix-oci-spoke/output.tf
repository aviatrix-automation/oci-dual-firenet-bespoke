output "vcn" {
  description = "The full Spoke OCI VCN object"
  value       = aviatrix_vpc.default
}

output "spoke_gateway" {
  description = "The full Aviatrix OCI Spoke Gateway object"
  value       = aviatrix_spoke_gateway.default
}