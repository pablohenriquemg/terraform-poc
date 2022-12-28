variable "basic_auth_username" {
  type        = string
  description = "The username to use for the basic auth configuration."
}

variable "basic_auth_password" {
  type        = string
  description = "The password to use for the basic auth configuration."
}

variable "gh_access_token" {
  type        = string
  description = "Personal Access token for 3rd party source control system for an Amplify App, used to create webhook and read-only deploy key. Token is not stored."
}

variable "enable_basic_auth_globally" {
  default     = false
  type        = bool
  description = "To enable basic auth for all branches or not."
}