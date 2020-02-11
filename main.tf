variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "local"
}

provider "aws" {
  region  = var.region
  profile = var.environment == "local" ? "default" : "RumbleOn"
  version = "~> 2.40"
}

data "aws_ssm_parameter" "rds_password" {
  name            = "/fulfillment/${var.environment}/rds_password" # our SSM parameter's name
  with_decryption = false
}

data "aws_ssm_parameter" "hasura_admin_secret" {
  name            = "/fulfillment/${var.environment}/hasura-access-key" # our SSM parameter's name
  with_decryption = false
}

data "aws_ssm_parameter" "hasura_jwt_hmac_key" {
  name            = "/fulfillment/${var.environment}/hasura_jwt_hmac_key" # our SSM parameter's name
  with_decryption = false
}

variable "rds_instance" {
  type = map
  default = {
    "local"       = "db.t2.micro"
    "development" = "db.t3.small"
    "qa"          = "db.t3.small"
    "production"  = "db.t3.medium"
  }
}

module "RumbleOn_hasura" {
  source                         = "github.com/RumbleOn/terraform-aws-hasura"
  region                         = "us-east-1"
  domain                         = "${var.environment == "local" ? "rumbleonsandbox" : "rumbleonfc"}.com"
  app_subdomain                  = "${var.environment == "production" ? "" : "${var.environment}-"}api"
  hasura_subdomain               = "${var.environment == "production" ? "" : "${var.environment}-"}api"
  hasura_admin_secret            = data.aws_ssm_parameter.hasura_admin_secret.value #"abc123"
  hasura_jwt_secret_key          = data.aws_ssm_parameter.hasura_jwt_hmac_key.value #"CHbuwrmbs7Hr4a5OQgvDLRQvjoNmKzZD"
  hasura_version_tag             = "v1.0.0"
  hasura_console_enabled         = "${var.environment == "production" ? "false" : "true"}"
  rds_db_name                    = "fulfillment"
  rds_instance                   = var.rds_instance[var.environment]
  rds_username                   = "userHasura"
  rds_password                   = data.aws_ssm_parameter.rds_password.value
  create_iam_service_linked_role = false
}
