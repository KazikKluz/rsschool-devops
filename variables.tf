variable "aws_region" {
  description = "Region in which AWS Resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "repository" {
  description = "GitHub repository used in CICD pipeline"
  type        = string
  default     = "repo:KazikKluz/rsschool-devops-course-tasks:*"
}

variable "account_id" {
  description = "Account id needed for full OIDC string"
  type        = string
  default     = "637423385007"
}