variable "replication" {
  type    = bool
  default = true
}

variable "generate_random_password" {
  type    = bool
  default = false
}

variable "random_password_length" {
  type    = number
  default = 25
}

variable "gsa_list" {
  description = "List of Service Account emails to be able to view secret"
  type        = list
  default     = []
}

variable "group_list" {
  description = "List of group emails to be able to view secret"
  type        = list
  default     = []
}
