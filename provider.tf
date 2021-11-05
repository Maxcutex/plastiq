provider "aws" {
      region     = "${var.aws_region}"
      alias = "vpc_first_region"
}
provider "aws" {
      region     = "${var.aws_region2}"
      alias       = "vpc_second_region"
}
provider "aws" {
  alias = "acm_provider"
  region = "us-east-1"
}