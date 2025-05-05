# AWS VPC Network Basic Setup

This Terraform configuration creates a basic VPC setup in AWS with the following components:

- VPC with configurable CIDR block
- 2 Public Subnets
- 2 Private Subnets
- Internet Gateway
- NAT Gateway (for private subnet internet access)
- Appropriate route tables and associations

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.0.0)

## State Management

This project uses an S3 bucket for Terraform state management. Before running Terraform, you need to create an S3 bucket and DynamoDB table for state locking.

1. Create an S3 bucket for Terraform state:

```bash
aws s3api create-bucket \
    --bucket your-terraform-state-bucket \
    --region us-east-1
```

2. Enable versioning on the S3 bucket:

```bash
aws s3api put-bucket-versioning \
    --bucket your-terraform-state-bucket \
    --versioning-configuration Status=Enabled
```

Replace `your-terraform-state-bucket` with your actual bucket name.

## Usage

1. Initialize Terraform with backend configuration:

```bash
terraform init
```

OR using a backend config

```bash
terraform init -backend-config=envs/<env>/backend.config
```

2. Review the planned changes:

```bash
terraform plan
```

3. Apply the configuration:

```bash
terraform apply
```

## Variables

The following variables can be customized:

- `aws_region`: AWS region to deploy resources (default: "us-west-2")
- `vpc_cidr`: CIDR block for the VPC (default: "10.0.0.0/16")
- `project_name`: Name of the project, used for resource naming (default: "network-basic")
- `public_subnet_count`: Number of public subnets to create (default: 2)
- `private_subnet_count`: Number of private subnets to create (default: 2)

To override any of these variables, you can either:

- Create a `terraform.tfvars` file: `terraform apply -var-file="envs/<env>/terraform.tfvars`
- Pass them via command line: `terraform apply -var="vpc_cidr=192.168.0.0/16"`

## Network Layout

The configuration creates the following network layout:

- VPC: Uses the specified CIDR block
- Public Subnets: Number of subnets specified by `public_subnet_count` in the VPC CIDR range
- Private Subnets: Number of subnets specified by `private_subnet_count` in the VPC CIDR range
- NAT Gateway: Placed in the first public subnet
- Internet Gateway: Attached to the VPC

## Cleanup

To destroy all created resources:

```bash
terraform destroy
```

Note: The S3 bucket and DynamoDB table created for state management will need to be deleted manually if you want to remove them.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please make sure to update tests as appropriate and adhere to the existing code style.
