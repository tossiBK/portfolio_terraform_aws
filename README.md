# A simple website on AWS with Terraform

Repository for the implementation of the IaC for a simple website,in multiple regions with a high availability.

## Prerequisites

* An AWS account with the AWS CLI installed and API key configured in the AWS CLI ([link to guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
* Installation of Terraform on the used OS ([link to guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
* Having a Domain registered in Area 53
* Creating a key on each target region for the SSH access to the server ([link to guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html))

## Installation & run:
1. Open console in the root folder of the project
2. To initialize all modules and the plugin for AWS call:
  ```
  terraform init
  ```
3. To run the code call:
  ```
  terraform apply -auto-approve
  ```

## Using the Module for a region creation:
As many regions as available in your account can be used. Each region needs its own module block.
1. Copy the block with the module “region_{name}” {}

```
module "region_europe" {
  source = "./modules/region-builder"
  region = var.region_europe
  az_1 = "eu-central-1a"
  az_2 = "eu-central-1b"
  domain = "your_domain"
  key_name = "your_key_file_name”
}
```

2. Replace the values:
   - Region: with the target region
   - az_1: first availability zone you want to use in that region
   - az_2: second availability zone you want to use in that region
   - domain: your domain name which you want to use and is registered in Area 53
3. run “terraform init” in the console again
  ```
  terraform init
  ```
5. run “terraform apply -auto-approve” for the provisioning
  ```
  terraform apply -auto-approve
  ```
