
module "terraform_state_backend" {
  source         = "cloudposse/tfstate-backend/aws"
  s3_bucket_name = "state-terraform-richtman-au"

  terraform_backend_config_file_path = "../root"
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false

  profile             = "root"
  dynamodb_table_name = "state-lock-terraform"
}
