variable "region" {
  description = "AWS Region"
  type = string
  default = ""
}

variable "account_id" {
  description = "List of Allowed AWS account IDs"
  type = list(string)
  default = [""]
}

variable "prefix" {
  description = "prefix for aws resources and tags"
  type = string
}

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier for VPC"
  type = string
}

variable "ami_id" {
  description = "AMI - Amazon Linux 2"
  type = string
  default = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = ""
}

variable "key_name" {
  description = "Key Name to use for the gitlab host"
  type = string
  default = ""
}

variable "key_path" {
  description = "Key Path to use for the gitlab host"
  type = string
  default = ""
}

variable "root_volume_type" {
  description = "The type of root volume. (gp3, gp2, io1, io2, standard)"
  type = string
  default = ""
}

variable "root_volume_size" {
  description = "The size of the root volume in gigabytes"
  type = number
}

variable "ebs_volume_type" {
  description = "The type of ebs volume. (gp3, gp2, io1, io2, standard)"
  type = string
  default = ""
}

variable "ebs_volume_size" {
  description = "The size of the ebs volume in gigabytes"
  type = number
}

variable "ebs_volume_mount" {
  description = "EBS vloume mount to directory"
  type = string
}

variable "kms_arn_ebs" {
  description = "KMS ARN for EBS"
  type = string
  default = ""
}

variable "gitlab_ingress_sg_rule" {
  description = "Ingress Security Group rule for gitlab"
  type = list(string)
  default = []
}

variable "subnet_id" {
  description = "gitlab subnet"
  type = string
  default = ""
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
  default = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
}

variable "s3_for_gitlab" {
  description = "A map of s3 bucket list"
  type = list(string)
}