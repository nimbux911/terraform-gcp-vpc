# vpc module variables
variable "existing" {
  type    = bool
  default = false
}

variable "routing_mode" {
  type        = string
  default     = "REGIONAL"
  description = "The network-wide routing mode to use. Possible values are REGIONAL and GLOBAL"
}

variable "subnet_region" {
  type        = string
  default     = "us-east1"
  description = "GCP Region"
}

variable "project_id" {
  type        = string
  description = "GCP Project Id"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name"
}

variable "subnet_cidr" {
  type        = string
  description = "Subnet CIDR block"
}

variable "subnet_description" {
  type        = string
  description = "Subnet description"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'stg', 'dev'"
}