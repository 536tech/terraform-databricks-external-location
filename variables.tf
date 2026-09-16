variable "name" {
  description = "External location name."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.name)) > 0, false)
    error_message = "name must not be empty or blank."
  }
}

variable "url" {
  description = "Storage URL, for example abfss://container@account.dfs.core.windows.net/path."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.url)) > 0, false)
    error_message = "url must not be empty or blank."
  }
}

variable "credential_name" {
  description = "Storage credential that grants access to the URL."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.credential_name)) > 0, false)
    error_message = "credential_name must not be empty or blank."
  }
}

variable "isolation_mode" {
  description = "Isolation mode: ISOLATION_MODE_OPEN or ISOLATION_MODE_ISOLATED."
  type        = string

  validation {
    condition     = var.isolation_mode == null ? true : contains(["ISOLATION_MODE_OPEN", "ISOLATION_MODE_ISOLATED"], var.isolation_mode)
    error_message = "isolation_mode must be ISOLATION_MODE_OPEN or ISOLATION_MODE_ISOLATED."
  }
}

variable "owner" {
  description = "External location owner. A user, group, or service principal."
  type        = string

  validation {
    condition     = var.owner == null ? true : try(length(trimspace(var.owner)) > 0, false)
    error_message = "owner must not be empty or blank."
  }
}

variable "read_only" {
  description = "Limit the location to read access."
  type        = bool
}

variable "fallback" {
  description = "Let the workspace fall back to cluster credentials when the location has no access."
  type        = bool
}

variable "enable_file_events" {
  description = "Turn on file events for the location."
  type        = bool
}

variable "comment" {
  description = "External location description."
  type        = string
  default     = null
}

variable "grants" {
  description = "Direct location grants. A list permits computed service principal application IDs."
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default  = []
  nullable = false

  validation {
    condition = try(alltrue([for grant in var.grants :
      length(trimspace(grant.principal)) > 0 && length(grant.privileges) > 0 &&
      alltrue([for privilege in grant.privileges : length(trimspace(privilege)) > 0])
    ]) && length(distinct([for grant in var.grants : grant.principal])) == length(var.grants), false)
    error_message = "Each grant needs a unique nonblank principal and at least one nonblank privilege."
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete the location while tables still reference it."
  type        = bool
  default     = false
}
