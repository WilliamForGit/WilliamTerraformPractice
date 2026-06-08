variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "swedencentral"
}

variable "project_name" {
  description = "Short name used as a prefix for all resources"
  type        = string
  default     = "wtp"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    project    = "WilliamTerraformPractice"
    managed_by = "Terraform"
    owner      = "William"
  }
}