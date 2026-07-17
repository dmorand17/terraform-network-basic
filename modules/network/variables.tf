variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Name of the project, used for resource naming"
  type        = string
  default     = "network-basic"
}

variable "tags" {
  description = "Additional tags applied to resources created by this module. Caller's provider default_tags are usually preferred for cross-cutting tags."
  type        = map(string)
  default     = {}
}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2
}

variable "interface_vpc_endpoints" {
  description = "Service short names for Interface VPC endpoints to create in the private subnets (e.g. ec2, ssm). Set to [] to create none."
  type        = list(string)
  default     = ["ec2", "ssmmessages", "ec2messages", "ssm"]
}

variable "create_gateway_endpoints" {
  description = "Create the S3 and DynamoDB Gateway VPC endpoints on the private route table. Set to false to skip them."
  type        = bool
  default     = true
}
