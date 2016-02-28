// file: variables.tf

variable "aws_access_key" {
  description = "the AWS access key ID"
}

variable "aws_secret_key" {
  description = "the AWS secret access key"
}

variable "environment_type" {
  description = "the type of environment for the cluster (dev or prod)"
  default = "dev"
}

variable "environment_label" {
  description = "the label associated with the environment"
  default = "dwc"
}

variable "cluster_image_id" {
  description = "the ID of the desired EC2 AMI to use"
}

variable "cluster_instance_type" {
  description = "the type of EC2 instance to use"
}

variable "cluster_max_size" {
  description = "the maximum size of the discovery cluster"
}

variable "cluster_min_size" {
  description = "the minimum size of the discovery cluster"
}

variable "label" {
  description = "the label associated with the cluster"
}

variable "owner" {
  description = "the owner of the cluster resources"
}

variable "region" {
  description = "the AWS region to use"
  default = "us-east-1"
}

variable "ssh_key" {
  description = "the name of the SSH key to associate with the each instance"
}