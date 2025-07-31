# Declaration des type de variables qui vont etre utilise
variable "provider_region" {
  type = string
}
variable "secret_access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "server_instance_type" {
  type = string
}
variable "ami_instance_type" {
  type = string
}
variable "server_tag_name" {
  type = string
}
variable "security_group_name" {
  type = string
}
variable "ssh_public_key_path" {
  type        = string
}
