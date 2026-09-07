mock_provider "databricks" {}

variables {

  name               = "lake_raw"
  url                = "abfss://raw@lake.dfs.core.windows.net/"
  credential_name    = "lake_cred"
  isolation_mode     = "ISOLATION_MODE_ISOLATED"
  owner              = "data-platform"
  read_only          = false
  fallback           = false
  enable_file_events = true

  grants = [{
    principal  = "data-engineers"
    privileges = ["READ_FILES", "WRITE_FILES"]
  }]
}

run "documented_example" {
  command = apply

  assert {
    condition     = databricks_external_location.this.name == var.name
    error_message = "The resource must preserve its configured name."
  }

  assert {
    condition     = length(databricks_grants.this) == 1
    error_message = "Configured access must have stable resource addresses."
  }
}

run "without_access" {
  command = plan

  variables {
    grants = []
  }

  assert {
    condition     = length(databricks_grants.this) == 0
    error_message = "Empty access must omit the access resources."
  }
}
