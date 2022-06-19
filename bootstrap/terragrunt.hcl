
include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "../shared/root-provider.tf"
}
