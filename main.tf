terraform {
  required_providers {
    aws = {
      version = "~>4.0"
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
}
resource "aws_instance" "instances" {
  for_each          = var.instances_info
  ami               = each.value.ami_id
  instance_type     = each.value.instance_type
  key_name          = each.value.key_name
  availability_zone = each.value.availability_zone
  vpc_security_group_ids   = ["sg-0f56a725e3cae5d71"]
  tags = {
    "Name" = each.key
  }
}
resource "null_resource" "null" {
  for_each = var.instances_info
  triggers = {
    instance = var.null
  }
  connection {
    host        = aws_instance.instances[each.key].public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    type        = "ssh"
  }
  provisioner "file" {
    source = "ansiblesetup.sh"
    destination = "ansiblesetup.sh"
  }
    provisioner "file" {
    source = "project1.yml"
    destination = "project1.yml"
  }
  provisioner "file" {
    source = "hosts"
    destination = "hosts"
  }
  provisioner "remote-exec" {
    inline = [
       "sudo chmod +x ansiblesetup.sh",
       "sh ./ansiblesetup.sh",
       "sudo cp /home/ubuntu/project1.yml /home/ubuntu/hosts /home/jenkins/ ",
       "sudo -u jenkins ansible-playbook -i /home/jenkins/hosts /home/jenkins/project1.yml"
    ]
  }
  

  depends_on = [
    aws_instance.instances
  ]
}
output "public_ip" {
  value = "${aws_instance.instances["ansible"].public_ip}"
}
output "private_dns" {
  value = "${aws_instance.instances["ansible"].private_dns}"
  
}
