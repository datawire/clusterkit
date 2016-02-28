// file: variables.tf

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

variable "environment" {
  description = "the environment for the cluster"
}

variable "name" {
  description = "the name for the cluster"
}

variable "owner" {
  description = "the owner of the cluste resources"
}

variable "region" {
  description = "the AWS region to use"
}

variable "ssh_key" {
  description = "the name of the SSH key to associate with the each instance"
}

variable "subnets" {
  description = "a CSV list of subnets contained within the specified VPC"
}

variable "vpc" {
  description = "the ID of the VPC to use"
}