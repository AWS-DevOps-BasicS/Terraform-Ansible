variable "region" {
  type = string
}
variable "sg_name" {
  type = string
}
variable "instances_info" {
  type = map(object({
    ami_id            = string 
    instance_type     = string
    key_name          = string
    availability_zone = string
  }))
}
variable "null" {
  type = string
}