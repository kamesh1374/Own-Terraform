
-----------------------------------------------------------------------------------------------
variable "instance_type"{
    description = "Instance type t2.micro"
    type = string
    default = "t2.micro"
}

variable "ami_id"{
    description ="ami for linux  ec2 instance"
    default = "ami-0cff7528ff583bf9a"
}

variable "key_name" {
    description = "key name for linux server"
    default = "terraform"


}