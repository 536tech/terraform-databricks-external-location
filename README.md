# Databricks external location Terraform module

One Unity Catalog external location.

Creates one external location on top of a storage credential and, when `grants` is not empty, one `databricks_grants` block on it.

## Resources

- `databricks_external_location.this`
- `databricks_grants.this[0]` (count = 1 only when `grants` is not empty)

The resource addresses above are part of the DataTF import contract. Do not rename them.

## Usage

```hcl
module "external_location" {
  source  = "536tech/external-location/databricks"
  version = "1.0.0"

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
```

## Compatibility

Configure the Databricks provider in the calling root with a workspace endpoint.
This resource module is also used by the
[workspace pattern module](https://registry.terraform.io/modules/536tech/workspace/databricks/latest).
Each repository has its own releases. Consumers select an exact tested module version.

The resource addresses match the original workspace submodule in version 0.1.1.
To migrate a direct submodule call, change its source and version. Keep the module block name.
Run `terraform init` and require a plan with no resource changes.
DataTF exports continue to use the workspace pattern module and its existing import addresses.

## Development

Use Terraform 1.7 or later for the mock tests. The module supports Terraform 1.5 or later.

```sh
prek install
terraform init -backend=false -lockfile=readonly
terraform validate
terraform test
tflint --recursive
prek run --all-files
```

CI tests the committed provider version and the minimum supported provider, 1.128.0.
The workspace pattern module checks the complete DataTF contract and its integration behavior.

## License

[Apache-2.0](LICENSE).

## Input safeguards

The module rejects blank required names and invalid access inputs during the plan.
Cross-input preconditions preserve the Terraform 1.5 minimum and existing resource addresses.
Null remains valid for inputs where the provider supplies a default.
Provider and API checks still apply. These checks do not prove complete permission visibility.

Each grant needs one unique principal and at least one nonblank privilege.
The module does not freeze the Unity Catalog privilege list; the provider and API check supported privileges.
`databricks_grants` manages the complete direct grant set on the object.
Preserve the caller's required grants and review the plan before apply.
Empty grants omit the grant resource; they do not declare an empty authoritative grant set.
See [provider grant semantics](https://github.com/databricks/terraform-provider-databricks/blob/v1.130.0/docs/resources/grants.md).

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_external_location.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location) (resource)
- [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) (resource)

## Required Inputs

The following input variables are required:

### credential\_name

Description: Storage credential that grants access to the URL.

Type: `string`

### enable\_file\_events

Description: Turn on file events for the location.

Type: `bool`

### fallback

Description: Let the workspace fall back to cluster credentials when the location has no access.

Type: `bool`

### isolation\_mode

Description: Isolation mode: ISOLATION\_MODE\_OPEN or ISOLATION\_MODE\_ISOLATED.

Type: `string`

### name

Description: External location name.

Type: `string`

### owner

Description: External location owner. A user, group, or service principal.

Type: `string`

### read\_only

Description: Limit the location to read access.

Type: `bool`

### url

Description: Storage URL, for example abfss://container@account.dfs.core.windows.net/path.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### comment

Description: External location description.

Type: `string`

Default: `null`

### force\_destroy

Description: Allow Terraform to delete the location while tables still reference it.

Type: `bool`

Default: `false`

### grants

Description: Direct location grants. A list permits computed service principal application IDs.

Type:

```hcl
list(object({
    principal  = string
    privileges = list(string)
  }))
```

Default: `[]`

## Outputs

The following outputs are exported:

### id

Description: External location id.

### name

Description: External location name.

### url

Description: External location URL.
<!-- END_TF_DOCS -->
