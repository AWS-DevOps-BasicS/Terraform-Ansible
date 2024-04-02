region            = "us-east-1"
sg_name           = "all_clear"
instances_info = {
  "ansible" = {
    ami_id            = "ami-0fc5d935ebf8bc3bc"
    instance_type     = "t2.micro"
    key_name          = "impkey"
    availability_zone = "us-east-1a"
  }
}
null = "012"