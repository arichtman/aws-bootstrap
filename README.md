
# aws-bootstrap

Bootstrap layer Terraform module

```Bash
aws configure --profile root

aws configure sso

# I expect
# prod-pu = Production Power User
# np-pu = Nonprod Power User
# root-adm = Root AWS account IAM admin account
# root = Root AWS account root account

# Bootstrap remote state bucket and DynamoDB
cd bootstrap
terragrunt apply

cd ..
terragrunt run-all apply

```
