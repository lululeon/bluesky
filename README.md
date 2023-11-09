# :cloud: Blue Sky VPC

This repo provisions a VPC with 2 public and 2 private subnets using an S3+Dynamodb Backend, with standard CIDRs, basic resource tagging and naming baked in for simplicity.

![diagram of vpc](./diagrams/bluesky_vpc.png)

Requirements:

- an AWS account (a terraform user) that has the necessary permissions to build infra
- have followed the instructions to set up your encrypted [s3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) here
- You have created an EC2 Key Pair for logging into your servers

## Setup & Deploy

<details>
  <summary>Expand for <b>LOCAL DEV SETUP</b> instructions </summary>

:warning: All command are run from the project root directory.

### After cloning this repo:

- use `.env.example` template to create `.env` file
- modify `.env` file with terraform user's credentials and other variables as needed
- `make tf:init`
  :point_up: if having trouble with creds, try clearing everything with `unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN` and re-check you have right key names and values before continuing with debugging the issue.

### Preparing to deploy:

- `make tf.validate`
- `make tf.format`
- `make tf.plan`

### Deployment

- `make tf.apply`

### Tear Down

- `make tf.destroy`

</details>

<details>
  <summary>Expand for <b>CI/CD PIPELINE</b> instructions </summary>

(TODO...)

</details>

<details>
  <summary>Expand for <b>HOW TO CONNECT TO YOUR SERVERS</b> instructions </summary>

1. For greatest ease of use:

   - make sure your keypair file is locked down (`chmod 400`)
   - make sure your keypair is available in the folder that you will be in when you attempt ssh.

1. **You need to copy across your key file to your bastion host BEFORE you get into the machine.**
   If you look at the format of the command, it has the same form as the ssh command, in that it requests access into the machine. Requesting access into the machine _when you've already ssh'ed into it_ doesn't make sense, so do this before ssh'ing in:

   - `scp -i <keypair.pem> <keypair.pem> ec2-user@ec2-x-x-x.compute-1.amazonaws.com:~/`

   (:point_up: This deposits your key file into your root directory, for example. You can get the exact hostname for your ec2 instance from your aws mgt console > **EC2 > Instances > (select instance) > Connect** and then go the **ssh tab** in that UX).

1. **Now** you can ssh in to your bastion host, eg:

   - `ssh -i <keypair.pem> ec2-user@ec2-x-x-x.compute-1.amazonaws.com`

1. You can ssh into your private server from your bastion host now, following a similar process, since your keyfile is now on your bastion host: `ssh -i <keypair.pem> ubuntu@x.x.x.x` (again: get your exact hostname from the mgt console).

Once you're sure everything works, you should add your key to your keyring and place it somewhere intelligent so that you can just ssh without specifying it each time or having to make sure you're in a specific directory.

</details>
