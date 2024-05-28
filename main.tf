# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Define variables for customization
variable "vpc_id" {
  type = string
  default = "vpc-000000000000000000" # Replace with your existing VPC ID
}

variable "availability_zone_a" {
  type = string
  default = "us-east-1a"
}

variable "availability_zone_b" {
  type = string
  default = "us-east-1b"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "ami" {
  type = string
  default = "ami-0aa7d40eeae50c9a9" # Replace with the desired AMI ID
}

variable "key_name" {
  type = string
  default = "your-key-pair-name" # Replace with your existing Key Pair Name
}

variable "bucket_name" {
  type = string
  default = "my-bucket"
}

# Create two subnets
resource "aws_subnet" "subnet_a" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone_a
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.availability_zone_b
  map_public_ip_on_launch = true
}

# Create two EC2 instances
resource "aws_instance" "ec2_instance_1" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_a.id
  key_name      = var.key_name

  tags = {
    Name = "ec2-instance-1"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_b.id
  key_name      = var.key_name

  tags = {
    Name = "ec2-instance-2"
  }
}

# Create a S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "my-bucket"
  }
}

# Create an SQS Queue
resource "aws_sqs_queue" "sqs_queue" {
  name = "my-sqs-queue"
}
