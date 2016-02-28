// main.tf

provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "template_file" "cluster_fqn" {
  lifecycle {
    create_before_destroy = true
  }
  template = "${var.environment_type}_${var.label}"
}

resource "template_file" "environment_fqn" {
  lifecycle {
    create_before_destroy = true
  }
  template = "${var.environment_type}_${var.region}_${var.environment_label}"
}

resource "terraform_remote_state" "foundation" {
  backend = "s3"
  config {
    bucket = "d6e-terraform-state"
    key = "${template_file.environment_fqn.rendered}/foundation"
    region = "${var.region}"
  }
}

module "ansible_config" {
  source = "modules/ansible"
  region = "${var.region}"
  cluster_fqn = "${template_file.cluster_fqn.rendered}"
}

module "cluster" {
  source = "modules/cluster"
  cluster_image_id = "${var.cluster_image_id}"
  cluster_instance_type = "${var.cluster_instance_type}"
  cluster_max_size = "${var.cluster_max_size}"
  cluster_min_size = "${var.cluster_min_size}"
  environment = "${template_file.environment_fqn.rendered}"
  name = "${template_file.cluster_fqn.rendered}"
  owner = "${var.owner}"
  region = "${var.region}"
  ssh_key = "${var.ssh_key}"
  subnets = "${terraform_remote_state.foundation.output.public_subnets}"
  vpc = "${terraform_remote_state.foundation.output.vpc_id}"
}