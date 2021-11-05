
variable "aws_region" {
  description = "First AWS region for the first VPC"

  type    = string
  default = "us-east-1"
}

variable "aws_region2" {
  description = "Second AWS region for the second VPC."

  type    = string
  default = "us-east-2"
}


variable "first_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the first VPC"
}

variable "first_public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "first_private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}



variable "second_cidr_block" {
  default     = "10.1.0.0/16"
  type        = string
  description = "CIDR block for the second VPC"
}

variable "second_public_subnet_cidr_blocks" {
  default     = ["10.1.0.0/24", "10.1.2.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "second_private_subnet_cidr_blocks" {
  default     = ["10.1.1.0/24", "10.1.3.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones_first" {
  default     = ["us-east-1a", "us-east-1b"]
  type        = list
  description = "List of availability zones"
}

variable "availability_zones_second" {
  default     = ["us-east-2a", "us-east-2b"]
  type        = list
  description = "List of availability zones"
}

variable "ssh-location" {
  default = "0.0.0.0/0"
  description = "IP Address that can SSH into the EC2 Instance"
  type = string
}

variable "s3_force_destroy" {
  type        = string
  description = "Destroy the s3 bucket inspite of contents in it."
  default     = "false"
}

variable "index_document" {
  type        = string
  description = "Index page to be used for website. Defaults to index.html"
  default     = "index.html"
}

variable "error_document" {
  type        = string
  description = "Error page to be used for website. Defaults to error.html"
  default     = "error.html"
}

variable "sub_domain_name" {
  type = string
  description = "The sub domain name for the website."
  default = "mycoolsite.sandbox.plastiq.com"
}

variable "bucket_name" {
  type = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
  default = "mycoolsite.sandbox.plastiq.com"
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}