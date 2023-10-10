# :cloud: Blue Sky VPC

This repo provisions a VPC with 2 public and 2 private subnets using an S3+Dynamodb Backend, with standard CIDRs, basic resource tagging and naming baked in for simplicity.

Requirements:

- an AWS account (a terraform user) that has the necessary permissions to build infra
- have followed the instructions to set up your encrypted [s3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) here

## Setup & Deploy

<details>
  <summary>Expand for <b>LOCAL DEV SETUP</b> instructions </summary>

### After cloning this repo:

- use `.env.example` template to create `.env` file
- If you wish to override the default values in `variables.tf`, make a copy of `.tfvars.example` -> `terraform.tfvars`. Do not check in the .tfvars file.
- modify `.env` file with terraform user's credentials and other variables
- `make envkeys` - to export env keys from your local .env file (for local dev only)
- `terraform init`

### Preparing to deploy:

- `terraform fmt`
- `terraform validate`
- `terraform plan`

### Deployment

- `terraform apply`

Tear Down

- `terraform destroy`

Lastly, if you want to deploy locally, copy `sample.tfvars` -> `terraform.tfvars`. Do **NOT** check in the latter!

</details>

<details>
  <summary>Expand for <b>CI/CD PIPELINE</b> instructions </summary>

(TODO...)

</details>

<details>
  <summary>Expand for <b>HOW TO CONNECT TO YOUR SERVERS</b> instructions </summary>

(TODO...)

</details>
