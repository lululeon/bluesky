# :cloud: Blue Sky VPC

This repo provisions a VPC with 2 public and 2 private subnets using an S3+Dynamodb Backend, with standard CIDRs, basic resource tagging and naming baked in for simplicity.

Requirements:

- an AWS account (a terraform user) that has the necessary permissions to build infra
- have followed the instructions to set up your encrypted [s3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) here

## Setup & Deploy

<details>
  <summary>Expand for <b>LOCAL DEV SETUP</b> instructions </summary>

:warning: All command are run from the project root directory.

### After cloning this repo:

- use `.env.example` template to create `.env` file
- modify `.env` file with terraform user's credentials and other variables as needed
- `make envkeys` - to export env keys from your local .env file (for local dev only)
- `make tf:init`
  :point_up: if having trouble with creds, try clearing everything with `unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN` and re-check you have right key names and values before continuing with debugging the issue.

### Preparing to deploy:

- `make tf.validate`
- `make tf.plan`

### Deployment

- `make tf.apply`

Tear Down

- `make tf.destroy`

</details>

<details>
  <summary>Expand for <b>CI/CD PIPELINE</b> instructions </summary>

(TODO...)

</details>

<details>
  <summary>Expand for <b>HOW TO CONNECT TO YOUR SERVERS</b> instructions </summary>

(TODO...)

</details>
