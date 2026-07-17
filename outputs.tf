output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.network.private_subnet_ids
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.network.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = module.network.private_route_table_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.network.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID of the regional NAT Gateway"
  value       = module.network.nat_gateway_id
}

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 gateway VPC endpoint"
  value       = module.network.s3_vpc_endpoint_id
}

output "dynamodb_vpc_endpoint_id" {
  description = "ID of the DynamoDB gateway VPC endpoint"
  value       = module.network.dynamodb_vpc_endpoint_id
}

output "interface_vpc_endpoint_ids" {
  description = "Map of service short name to Interface VPC endpoint ID"
  value       = module.network.interface_vpc_endpoint_ids
}

output "vpc_endpoints_security_group_id" {
  description = "ID of the security group attached to the interface VPC endpoints"
  value       = module.network.vpc_endpoints_security_group_id
}
