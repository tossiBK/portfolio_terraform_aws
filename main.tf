# https://developer.hashicorp.com/terraform/language/modules

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

module "region_europe" {
  source = "./modules/region-builder"
  region = var.region_europe
  az_1 = "eu-central-1a"
  az_2 = "eu-central-1b"
  domain = "klahan.click"
  key_name = "cloud_programming_keypair"
}

module "region_asia" {
  source = "./modules/region-builder"
  region = var.region_asia
  az_1 = "ap-southeast-1a"
  az_2 = "ap-southeast-1b"
  domain = "klahan.click"
  key_name = "cloud_programming_keypair"
}