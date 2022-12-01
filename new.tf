provider "aws" {
   region = var.aws_region
   profile = "default"
   
}
#To create a bucket
terraform {
  backend "s3"{
  bucket = "variable_demo_task1"
  key ="terraform/terraform.tfstate"
  region = "us-east-1"
 }
}
#To create a Instance
resource "aws_instance" "trail" {
    #By Using AMI map
    ami = lookup(var.region_ami,var.aws_region)
    instance_type = var.instance_type
    key_name = var.key_name
    
    #By using local exe we can get Private ID
     provisioner "local-exec" {
      command = "echo ${self.private_ip}>>private_ips.txt"
       
     }
    tags = {
        Name = "Demo_Ec2"
           }
}
output "Instance-ip" {
   value = aws_instance.trail.private_ip
}