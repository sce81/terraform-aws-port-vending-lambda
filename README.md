# terraform-aws-port-vending-lambda

Standalone Terraform child module for the shared Port account-vending CTASK
Lambda. The default function name is `port-account-vending-ctask`; its AWS
region is selected exclusively by the caller's AWS provider configuration.

## What it creates

- A CloudWatch log group retaining logs for 14 days.
- A Lambda execution role with a least-privilege policy for that log group.
- An ARM64 Python 3.12 Lambda function packaged from `src/app.py`.
- A public Lambda Function URL and the matching invoke permission.

The handler always returns HTTP 200 with a JSON body. It accepts an optional
Function URL request body so it can evolve to process CTASK payloads, but it
does not require or read Port credentials or secrets.

## Usage

Configure the AWS provider in the root module, including `eu-west-1`, then
reference a released version of this module:

```hcl
provider "aws" {
  region = "eu-west-1"
}

module "port_account_vending_ctask" {
  source = "git::https://github.com/sce81/terraform-aws-port-vending-lambda.git?ref=v1.0.0"

  env     = "shared"
  project = "port"
  name    = "account-vending-ctask"

  extra_tags = {
    CostCenter = "platform"
  }
}
```

After applying the root module, send a request with:

```bash
curl "$(terraform output -raw function_url)"
```
