# AWS VPC Network Basic Setup

The reusable Terraform module lives at [`modules/network/`](./modules/network).
The repo root is a working example that consumes the module via the
`envs/<env>/` config files. See [Using as a module](#using-as-a-module) below.

This module creates a basic VPC setup in AWS with the following components:

- VPC with configurable CIDR block
- 'n' Public Subnets
- 'n' Private Subnets
- Internet Gateway
- Regional NAT Gateway (for private subnet internet access, multi-AZ)
- Gateway VPC Endpoints for S3 and DynamoDB (attached to the private route table)
- Appropriate route tables and associations

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.0.0)

## State Management

This project uses an S3 bucket for Terraform state management. Before running Terraform, you need to create an S3 bucket and DynamoDB table for state locking.

1. Create an S3 bucket for Terraform state:

```bash
AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET="tfstate-${ACCOUNT_ID}-${AWS_REGION}-an"
# BUCKET="REPLACE_ME"
aws s3api create-bucket \
    --bucket "${BUCKET}" \
    --bucket-namespace account-regional \
    --region "${AWS_REGION}"
```

2. Enable versioning on the S3 bucket:

```bash
aws s3api put-bucket-versioning \
    --bucket "${BUCKET}" \
    --versioning-configuration Status=Enabled \
    --region "${AWS_REGION}"
```

## Usage

1. Initialize Terraform with backend configuration:

```bash
terraform init -backend-config=envs/<env>/backend.config
```

2. Review the planned changes:

```bash
terraform plan -var-file=envs/<env>/terraform.tfvars
```

3. Apply the configuration:

```bash
terraform apply -var-file=envs/<env>/terraform.tfvars
```

### Using a variables file

Per-environment configuration lives under `envs/<env>/`. An example
environment is checked in at `envs/example/` containing:

- `backend.config` — backend settings passed to `terraform init`
- `terraform.tfvars.example` — sample input variables

Real `*.tfvars` files are gitignored. To use the example, copy it into a new
environment directory, edit as needed, and pass it to `plan` / `apply`:

```bash
mkdir -p envs/dev
cp envs/example/backend.config           envs/dev/backend.config
cp envs/example/terraform.tfvars.example envs/dev/terraform.tfvars

terraform init  -backend-config=envs/dev/backend.config
terraform plan  -var-file=envs/dev/terraform.tfvars
terraform apply -var-file=envs/dev/terraform.tfvars
```

## Using as a module

The networking resources are packaged as a child module at
[`modules/network/`](./modules/network) so they can be consumed from another
Terraform configuration:

```hcl
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "github.com/your-org/terraform-network-basic//modules/network"
  # or a local path: source = "../terraform-network-basic/modules/network"

  project_name         = "my-app"
  vpc_cidr             = "10.20.0.0/16"
  public_subnet_count  = 2
  private_subnet_count = 2
}
```

Notable behaviour:

- The module derives the AWS region from the caller's provider via
  `data.aws_region.current.name`, so you do not pass `aws_region`.
- The module declares no `provider` block and no backend — the caller owns
  both. Use the caller's provider `default_tags` for cross-cutting tags.

Module outputs include `vpc_id`, `vpc_cidr_block`, `public_subnet_ids`,
`private_subnet_ids`, `public_route_table_id`, `private_route_table_id`,
`internet_gateway_id`, `nat_gateway_id`, `s3_vpc_endpoint_id`, and
`dynamodb_vpc_endpoint_id`.

> **Migrating from a previous root-only layout:** if you have already applied
> this configuration before the module split, resource addresses moved from
> `aws_vpc.main` etc. to `module.network.aws_vpc.main`. Use `terraform state mv`
> for each resource to avoid a destroy/recreate.

## Variables

<!-- BEGIN_TF_DOCS -->

## Inputs

| Name                                                                                          | Description                                   | Type          | Default                                                                                                       | Required |
| --------------------------------------------------------------------------------------------- | --------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                               | AWS region to deploy resources                | `string`      | `"us-east-1"`                                                                                                 |    no    |
| <a name="input_private_subnet_count"></a> [private_subnet_count](#input_private_subnet_count) | Number of private subnets to create           | `number`      | `2`                                                                                                           |    no    |
| <a name="input_project_name"></a> [project_name](#input_project_name)                         | Name of the project, used for resource naming | `string`      | `"network-basic"`                                                                                             |    no    |
| <a name="input_public_subnet_count"></a> [public_subnet_count](#input_public_subnet_count)    | Number of public subnets to create            | `number`      | `2`                                                                                                           |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                 | A map of tags to assign to the resources. The `project` tag is added automatically from `project_name`.      | `map(string)` | <pre>{<br/> "environment": "dev",<br/> "managed-by": "terraform"<br/>}</pre> |    no    |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr)                                     | CIDR block for the VPC                        | `string`      | `"10.0.0.0/16"`                                                                                               |    no    |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id) | ID of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc_cidr_block](#output_vpc_cidr_block) | CIDR block of the VPC |
| <a name="output_public_subnet_ids"></a> [public_subnet_ids](#output_public_subnet_ids) | IDs of the public subnets |
| <a name="output_private_subnet_ids"></a> [private_subnet_ids](#output_private_subnet_ids) | IDs of the private subnets |
| <a name="output_public_route_table_id"></a> [public_route_table_id](#output_public_route_table_id) | ID of the public route table |
| <a name="output_private_route_table_id"></a> [private_route_table_id](#output_private_route_table_id) | ID of the private route table |
| <a name="output_internet_gateway_id"></a> [internet_gateway_id](#output_internet_gateway_id) | ID of the Internet Gateway |
| <a name="output_nat_gateway_id"></a> [nat_gateway_id](#output_nat_gateway_id) | ID of the regional NAT Gateway |
| <a name="output_s3_vpc_endpoint_id"></a> [s3_vpc_endpoint_id](#output_s3_vpc_endpoint_id) | ID of the S3 gateway VPC endpoint |
| <a name="output_dynamodb_vpc_endpoint_id"></a> [dynamodb_vpc_endpoint_id](#output_dynamodb_vpc_endpoint_id) | ID of the DynamoDB gateway VPC endpoint |

<!-- END_TF_DOCS -->

To override any of these variables, you can either:

- Use a per-env tfvars file (see [Using a variables file](#using-a-variables-file)): `terraform apply -var-file=envs/<env>/terraform.tfvars`
- Pass them via command line: `terraform apply -var="vpc_cidr=192.168.0.0/16"`

## Network Layout

The configuration creates the following network layout:

- VPC: Uses the specified CIDR block
- Public Subnets: Number of subnets specified by `public_subnet_count` in the VPC CIDR range
- Private Subnets: Number of subnets specified by `private_subnet_count` in the VPC CIDR range
- NAT Gateway: Regional NAT Gateway (`availability_mode = "regional"`) in auto mode — AWS manages EIPs and expands across AZs automatically
- Internet Gateway: Attached to the VPC
- Gateway VPC Endpoints: S3 and DynamoDB endpoints associated with the private route table so traffic to those services from private subnets stays on the AWS network (and avoids NAT data charges)

## Cleanup

To destroy all created resources:

```bash
terraform destroy
```

Note: The S3 bucket and DynamoDB table created for state management will need to be deleted manually if you want to remove them.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please make sure to update tests as appropriate and adhere to the existing code style.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
