
To Create a Ec2 Instance use AWS CLI command:
------------------------------------------------------

Create instance:
		 aws ec2 run-instances --image-id ami-0cff7528ff583bf9a --count 1 --instance-type t2.micro --key-name terraform --security-group-ids sg-0ac4427201fba0dcc --subnet-id subnet-08146c2b3b586514c

Create tag and add to instance:
		 aws ec2 create-tags --resources i-085564baedbd253a3 --tags Key=Name,Value=Demo

Aws ec2 instance list(filter):
		 aws ec2 describe-instances --filters "Name=tag:Name,Values=Demo" 

Aws ec2 instance list(filter & Query):
		aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId"

start /stop instance:
		 aws ec2 start/stop-instances --instance-ids i-085564baedbd253a3

Termininate instance:
		 aws ec2 terminate-instances --instance-ids i-085564baedbd253a3
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



To Create a Ec2 Instance :
-----------------------------
provider "aws" {
   profile = "default"---->cmmd--->aws configure
   
}

resource "aws_instance" "trail" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
        Name = "Ec2"
           }
}
output "Instance-ip" {
   value = aws_instance.trail.public_ip
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Variable.Tf:
------------
#for region
variable "aws_region" {
    default = "us-east-1"
  
}
#for instance type
variable "instance_type"{
    description = "Instance type t2.micro"
    type = string
    default = "t2.micro"
}
  
}

#for PEM or PPK key
variable "key_name" {
    description = "key name for linux server"
    default = "terraform"


}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create Security Group:
----------------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_security_group" "ssh_sg" {

  name = "SSH"

  description = "Allow SSH inbound traffic"

  vpc_id      = "vpc-0bb4647f032ebdc6e"

  ingress {

      from_port = 22

      to_port = 22

      protocol = "TCP"

      cidr_blocks = ["0.0.0.0/0"]

  }



  egress {

      from_port = 0

      to_port = 0

      protocol = "TCP"

      cidr_blocks = ["0.0.0.0/0"]

    }

}

output "ssh_Sg_id" {

    value = aws_security_group.ssh_sg.id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create a VPC :
--------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_vpc" "vpc" {

    cidr_block = "10.0.0.0/16"

    tags  = {

        name = "demovpc"

    }

}

output "vpc_id" {

    value = aws_vpc.vpc.id

 

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create a public and private Subnet:
------------------------------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_subnet" "demo_public_subnet" {
  vpc_id                  = "vpc-0aa6082ca42ffebc7"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name        = "demo_sub_public"
  }
}
output "public_subnetid" {
  value = aws_subnet.demo_public_subnet.id
}

resource "aws_subnet" "demo_private_subnet" {
  vpc_id                  = "vpc-0aa6082ca42ffebc7"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name        = "demo_sub_private"
  }
}
output "private_subnetid" {
  value = aws_subnet.demo_private_subnet.id
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create public Route Table :
--------------------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_route_table" "demo_public_rt" {

    vpc_id = "vpc-0aa6082ca42ffebc7"

    route {

        //associated subnet can reach everywhere

        cidr_block = "0.0.0.0/0"         //CRT uses this IGW to reach internet

        gateway_id = "${aws_internet_gateway.demo_igw.id}"

    }

    tags = {

        Name = "demo-public-rt"

    }

}

output "demo_Public_RT_id" {

  value = aws_route_table.demo_public_rt.id

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create a Private  Route Table:
-------------------------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_route_table" "demo_private_rt" {

    vpc_id = "vpc-0aa6082ca42ffebc7"  

    route {

        //associated subnet can reach everywhere

        cidr_block = "0.0.0.0/0"         //CRT uses this IGW to reach internet

        gateway_id = "${aws_nat_gateway.demo_natgateway.id}"

    }

    tags = {

        Name = "demo-private-rt"

    }

}

output "demo_Private_RT_id"{

    value = aws_route_table.demo_private_rt.id

}



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create IGW:
------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_internet_gateway" "demo_igw" {

    vpc_id = "vpc-0aa6082ca42ffebc7"

    tags = {

        Name = "demo-igw"

    }

}

output "internet_gateway_id" {

  value = aws_internet_gateway.demo_igw.id

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

To Create NAT:
-----------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_nat_gateway" "demo_natgateway"{

   allocation_id= "${aws_eip.demo_nat_eip.id}"

   subnet_id = "subnet-074353c18f4b7af3c"

    tags = {

      Name = "demo Natgateway"

          }

}

output "demo_natgateway_id" {

  value = aws_nat_gateway.demo_natgateway.id

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create a EIP:
------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_eip" "demo_nat_eip" {

  vpc = true

  tags = {

      Name = "demo_nat_eip"

  }

}

output "demo_nat_eip" {

  value = aws_eip.demo_nat_eip.id

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create Route Table Association Private:
----------------------------------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_route_table_association" "demo-private-routetable"{

    subnet_id = "subnet-00e50a1d0b48ed761"

    route_table_id = "${aws_route_table.demo_private_rt.id}"

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create Route Table Association Public:
--------------------------------------------
provider "aws" {
    region ="us-east-1"
    access_key = "AKIATPNRCDJ3ZRB7OIL6"
    secret_key = "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"
}
resource "aws_route_table_association" "demo-public-routetable"{

    subnet_id = "subnet-074353c18f4b7af3c"

    route_table_id = "${aws_route_table.demo_public_rt.id}"

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create Module:
--------------------
To create ec2:
---------------
resource "aws_instance" "demo_instance" {

  ami           = "ami-0cff7528ff583bf9a"

  instance_type = "t2.micro"

  key_name      = "terraform"

  tags = {

    "Name" = "demoec2"

  }

}
---------------------------------------------------------------
To s3 bucket:
--------------
resource "aws_s3_bucket" "Demo_bucket_name_s3" {

  bucket = "modbuckets123"

  acl    = "private"



  tags = {

    "Name"      = "Demo_bucket_123"

    Environment = "prod"

  }

}
---------------------------------------------------------------
provider "aws" {

  profile = "default"


}



module "ec2" {

  source = "./ec2"

}



module "s3" {

  source = "./s3"

}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Create S3 & Store Ec2 instance Terraform tf state in s3:
-----------------------------------------------------------------

#first here we need to create a bucket after process into EC2 instance

resource "aws_s3_bucket" "demos3Bedcducket" {
    bucket = "kameshtaskcase1"
    acl = "private"

    tags = {
      "Name" = "bucket1scaac23123"
      Environment = "prod"
    }
  
}

Create a s3 Bucket using variable.tf:
-----------------------------------------
variable "bucket_name" {

  default = "syedtaskdemo"

}

variable "acl_value" {

  default = "private"



}

variable "Environment" {

  description = "environment"

  default     = "prod"

}

(ii)To Create intsance and store terraformstate in s3 by backend:
----------------------------------------------------------------- 
provider "aws" {
   profile = "default"
   
}

terraform {
  backend "s3"{
  bucket = "kameshtaskcase1"
  key ="terraform/terraform.tfstate"
  region = "us-east-1"
 }
}

resource "aws_instance" "trail" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
        Name = "Ec2"
           }
}
output "Instance-ip" {
   value = aws_instance.trail.public_ip
}
----------------------------------------------------------------------------------------------------
To Create S3 & Store Ec2 instance Terraform tf state in s3 & To get Private ip using Local exe:
--------------------------------------------------------------------------------------------------------
#first here we need to create a bucket after process into EC2 instance

provider "aws" {
   region = var.aws_region
   profile = "default"
   
}
#Store tf state file in a bucket
terraform {
  backend "s3"{
  bucket = "kameshvariabledemotask1"
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
----------------------------------------------------------------------------------------------------
Variable.Tf:
------------
#for region
variable "aws_region" {
    default = "us-east-1"
  
}
#for instance type
variable "instance_type"{
    description = "Instance type t2.micro"
    type = string
    default = "t2.micro"
}
#for ami autogenerate
variable "region_ami" {
    type = map
    default = {
        #Ubuntu Server 20
        us-east-1 = "ami-08d4ac5b634553e16"
        us-west-1 = "ami-0d9858aa3c6322f73"
    }
  
}

#for PEM or PPK key
variable "key_name" {
    description = "key name for linux server"
    default = "terraform"


}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Run a instance using Data method or data soruce:
----------------------------------------------------------

(i)To create a instance:
-------------------------

	provider "aws" {
   profile = "default"
   
}
resource "aws_instance" "trail" {
    ami = data.aws_ami.server_ami.id
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
        Name = "Demo_Ec2"
           }
}
output "Instance-ip" {
   value = aws_instance.trail.private_ip
}

(ii)To create Variable:
------------------------

    variable "instance_type"{
    description = "Instance type t2.micro"
    type = string
    default = "t2.micro"
}

    variable "key_name" {
    description = "key name for ubuntu server"
    default = "terraform"


}

(iii)To create Data method or Data socure:
----------------------------------------------

	data "aws_ami" "server_ami" {
    most_recent = true
    owners   = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To Run a instance using Data method or data soruce & provisioner remote exe With Security Group:
------------------------------------------------------------------------------------------------------

provider "aws" {
   profile = "default"
   
}
resource "aws_instance" "trail" {
    ami = data.aws_ami.server_ami.id
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
        Name = "Demo_Ec2"
           }
        
  provisioner "remote-exec" {

    inline = [

      "touch hello.txt",

      "echo helloworld remote provisioner >>hello.txt",

    ]

  }

  connection {

    type        = "ssh"

    host        = self.public_ip

    user        = "ubuntu"

    private_key = file("C:/Users/Karthi/Downloads/Syedterraform.pem")

    timeout     = "4m"

  }

}



resource "aws_security_group" "ssh_sg" {

  name        = "ssh"

  description = "Allow SSH inbound traffic"

  vpc_id      = "vpc-05d4973aefe7ff8fb"

  ingress {

    from_port        = 22

    to_port          = 22

    protocol         = "TCP"

    security_groups  = []

    cidr_blocks      = ["0.0.0.0/0", ]

    description      = ""

    ipv6_cidr_blocks = []

    prefix_list_ids  = []

    self             = false





  }

  egress {

    from_port        = 0

    to_port          = 0

    protocol         = "-1"

    cidr_blocks      = ["0.0.0.0/0", ]

    description      = ""

    ipv6_cidr_blocks = []

    prefix_list_ids  = []

    security_groups  = []

    self             = false




  }
}
output "Instance-ip" {
   value = aws_instance.trail.private_ip
}

(ii)To create Variable:
------------------------

	variable "instance_type"{
    description = "Instance type t2.micro"
    type = string
    default = "t2.micro"
}

variable "key_name" {
    description = "key name for ubuntu server"
    default = "terraform"


}

(iii)To create Data method or Data socure:
----------------------------------------------

	data "aws_ami" "server_ami" {
    most_recent = true
    owners   = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}







----------------------------------------------------------------------------------------------------------------------------------------------------
CREATE A INSTANCE USING PROVISIONER REMOTE EXEC AND ALSO SOURCE ,DESTINATION:
------------------------------------------------------------------------------------------------
provider "aws" {

  profile = "default"

}

resource "aws_instance" "web" {

  ami                    = data.aws_ami.ubuntu_ami.id

  instance_type          = var.instance_type

  key_name               = var.key_name

  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {

    Name = "Ubuntu20"

  }



  /* provisioner "file" {

    source      = "D:/Mohanraj/testfile.txt/testfile.txt.txt" #we need to create and add the location

    destination = "/home/ubuntu/testfile.txt" #shows in ubuntu server



  }

  connection {

    type        = "ssh"

    host        = self.public_ip

    user        = "ubuntu"

    private_key = file("C:/Users/Karthi/Downloads/Syedterraform.pem")

    timeout     = "4m"

  }*/





  provisioner "remote-exec" {

    inline = [

      "touch hello.txt",

      "echo helloworld remote provisioner >>hello.txt",




    ]

  }



  connection {

    type        = "ssh"

    host        = self.public_ip

    user        = "ubuntu"

    private_key = file("C:/Users/Karthi/Downloads/Syedterraform.pem") #pem key path

    timeout     = "4m"

  }

}



resource "aws_security_group" "ssh_sg" {

  name        = "ssh"

  description = "Allow SSH inbound traffic"

  vpc_id      = "vpc-05d4973aefe7ff8fb"

  ingress {

    from_port        = 22

    to_port          = 22

    protocol         = "TCP"

    security_groups  = []

    cidr_blocks      = ["0.0.0.0/0", ]

    description      = ""

    ipv6_cidr_blocks = []

    prefix_list_ids  = []

    self             = false



  }

  egress {

    from_port        = 0

    to_port          = 0

    protocol         = "-1"

    cidr_blocks      = ["0.0.0.0/0", ]

    description      = ""

    ipv6_cidr_blocks = []

    prefix_list_ids  = []

    security_groups  = []

    self             = false



  }



}

resource "aws_key_pair" "deployer" {

  key_name   = "C:/Users/Karthi/Downloads/Syedterraform.pem"

  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzglFtH0E+Y/OTwqUe2iuzUzyUq9z/X5Re4F9a48usASJMvo297kj1f7yOSyx1fKDLvuYuHk32uvH0WosMYElnCBa6G90pPtQUzabPujL5VkBg5EkIR7Ec9x8l4ByYL5pBG6nPP0cy2/vG6Y10mbXLPvk3RYdUnzR9zCwD+SfgGrt9dba+ma8THqVpcsB0x0lNLjxK71SRA5qRkM6Hz/pHjMf9J7UibK0z2niEpK+/eLW4FGPI85c3nAk6OIkbkSZkRA767t8QcgakTcnI/SoRzmMtX5iCZUUjJXvRN9KRZpQFvQJCJZIzTSPIAVvPwtOwgbCr93c0aU8CW7tyAFK5"

}





#output

output "instance_ip" {

  value = aws_instance.web.public_ip

}
