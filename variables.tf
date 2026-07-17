variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

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
  description = "A map of tags to assign to the resources. The `project` tag is added automatically from `project_name`."
  type        = map(string)
  default = {
    environment = "dev"
    managed-by  = "terraform"
  }
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
  description = "Service short names for Interface VPC endpoints created in the private subnets (e.g. ec2, ssm). Set to [] to create none."
  type        = list(string)
  default     = ["ec2", "ssmmessages", "ec2messages", "ssm"]
}

variable "create_gateway_endpoints" {
  description = "Create the S3 and DynamoDB Gateway VPC endpoints on the private route table. Set to false to skip them."
  type        = bool
  default     = true
}
