aws_region   = "us-east-1"
project_name = "my-project"
vpc_cidr     = "172.16.0.0/16"

public_subnet_count  = 2
private_subnet_count = 2

tags = {
  environment = "dev"
  managed-by  = "terraform"
}
