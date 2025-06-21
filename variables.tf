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

variable "vpc_cidr" {
  description = "CIDR block for the entire VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR blok for the Public Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR blok for the Public Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR blok for the Private Subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR blok for the Private Subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  description = "set of VPC Availability Zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}
