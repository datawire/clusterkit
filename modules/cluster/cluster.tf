// file: cluster.tf

resource "template_file" "discovery" {
  template = "${file("${path.root}/bin/bootstrap.sh")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "cluster_group" {
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Note: The below rule is "ALLOW ALL INGRESS". It is convenient but not enabled by default to force developers to
  //       think about their network port requirements.
  //
  //  ingress {
  //    cidr_blocks = ["0.0.0.0/0"]
  //    from_port = 0
  //    protocol = "-1"
  //    to_port = 0
  //  }

  // common ports used by for web services and applications.
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    protocol = "tcp"
    to_port = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  lifecycle {
    create_before_destroy = true
  }
  name = "${var.name}"
  tags {
    Owner = "${var.owner}"
    Role = "dwc:networking:${var.name}"
  }
  vpc_id = "${var.vpc}"
}

resource "aws_launch_configuration" "cluster" {
  associate_public_ip_address = true
  enable_monitoring = false
  iam_instance_profile = "${aws_iam_instance_profile.cluster_member.name}"
  image_id = "${var.cluster_image_id}"
  instance_type = "${var.cluster_instance_type}"
  lifecycle {
    create_before_destroy = true
  }
  key_name = "${var.ssh_key}"
  name_prefix = "${var.name}-"
  security_groups = [
    "${aws_security_group.cluster_group.id}",
  ]
  user_data = "${template_file.discovery.rendered}"
}

resource "aws_autoscaling_group" "cluster" {
  force_delete = true
  health_check_grace_period = 90
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.cluster.id}"
  lifecycle {
    create_before_destroy = true
  }
  max_size = "${var.cluster_max_size}"
  min_size = "${var.cluster_min_size}"
  name = "${var.name}"
  tag {
    key = "Name"
    value = "${var.name}"
    propagate_at_launch = true
  }
  tag {
    key = "Role"
    value = "dwc:custom:${var.name}"
    propagate_at_launch = true
  }
  tag {
    key = "Owner"
    value = "${var.owner}"
    propagate_at_launch = true
  }
  vpc_zone_identifier = ["${split(",", var.subnets)}"]
  wait_for_capacity_timeout = "10m"
  wait_for_elb_capacity = "${var.cluster_min_size}"
} 
