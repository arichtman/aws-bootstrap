
resource "aws_organizations_organization" "root" {
  aws_service_access_principals = [
    "account.amazonaws.com",
    "sso.amazonaws.com",
  ]

  feature_set = "ALL"
}

resource "aws_organizations_account" "root" {
  name  = "root"
  email = "ariel+aws@richtman.com.au"
}

resource "aws_organizations_account" "nonprod" {
  name  = "nonprod"
  email = "ariel+awsnonprod@richtman.com.au"
}

resource "aws_organizations_account" "prod" {
  name  = "prod"
  email = "ariel+awsprod@richtman.com.au"
}

resource "aws_organizations_account" "backup" {
  name  = "backup"
  email = "ariel+awsbackup@richtman.com.au"
}
