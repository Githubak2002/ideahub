variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
