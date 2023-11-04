variable "aws_access_key" {
   default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable  "aws_region" {
    default = "us-east-2"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnets_cidr" {
    type = list
    default = ["10.0.1.0/24" , "10.0.2.0/24"] 
}

variable "availability_zones" {
    type = list
    default = ["us-east-2a" , "us-east-2b"]
}

variable "prod-instance-ami" {
    default = "ami-0a1c7c98281e3fead" # ubuntu - docker - wazuh - node exporter - 20 GB disk
}

variable "code_deploy_agent_name" {
    default = "CodeDeployAgent"
}

variable "code_deploy_role_arn" {
    default = "arn:aws:iam::047082177062:role/CodeDeployRole"
}