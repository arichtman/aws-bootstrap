
# aws-bootstrap

WIP of Terraformed AWS environments in use for personal projects.

```Bash
aws configure --profile root

aws configure sso

# Profile setup
# prod-pu = Production Power User
# np-pu = Nonprod Power User
# root-adm = Root AWS account IAM admin account
# root = Root AWS account root account

# Bootstrap remote state bucket and DynamoDB
aws sso login --profile root
cd bootstrap
terragrunt apply

```
