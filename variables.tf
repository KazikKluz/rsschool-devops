variable "aws_region" {
  description = "Region in which AWS Resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "repository" {
  description = "GitHub repository used in CICD pipeline"
  type        = string
  default     = "repo:KazikKluz/rsschool-devops:*"
}

variable "account_id" {
  description = "Account id needed for full OIDC string"
  type        = string
  default     = "475822813012"
}

variable "project" {
  description = "Name of the project"
  type        = string
  default     = "AWSDevOps"
}

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr_block" {
  description = "CIDR block for a new VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Default availability zones"
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "ssh_key" {
  type        = string
  description = "Key name used to connect to EC2 via SSH"
  default     = "terraform-key"
}

variable "instance_type" {
  type        = string
  description = "Type and family of EC2 instance"
  default     = "t2.micro"
}

variable "token" {
  description = "k3s token"
  type        = string
}

