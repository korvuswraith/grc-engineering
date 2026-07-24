package main

import rego.v1

deny contains msg if {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "aws_s3_bucket"
  not encryption_enabled(resource.address)
  msg := sprintf("FAIL: Bucket %v does not have encryption enabled", [resource.address])
}

deny contains msg if {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "aws_s3_bucket_public_access_block"
  resource.values.block_public_acls != true
  msg := sprintf("FAIL: Bucket %v does not block public ACLs", [resource.address])
}

deny contains msg if {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "aws_s3_bucket_versioning"
  resource.values.versioning_configuration[_].status != "Enabled"
  msg := sprintf("FAIL: Bucket %v does not have versioning enabled", [resource.address])
}

encryption_enabled(bucket_address) if {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "aws_s3_bucket_server_side_encryption_configuration"
  resource.values.rule[_].apply_server_side_encryption_by_default[_].sse_algorithm == "AES256"
}
