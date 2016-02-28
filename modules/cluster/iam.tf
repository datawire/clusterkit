// file: iam.tf

resource "template_file" "iam_role" {
  lifecycle {
    create_before_destroy = true
  }
  template = "${file("${path.root}/etc/iam/cluster_role.json")}"
}

resource "template_file" "iam_policy" {
  template = "${file("${path.root}/etc/iam/cluster_policy.json")}"
}

resource "aws_iam_role" "cluster_member" {
  lifecycle {
    create_before_destroy = true
  }
  name = "${var.name}_${var.owner}"
  assume_role_policy = "${template_file.iam_role.rendered}"
}

resource "aws_iam_role_policy" "cluster_member" {
  name = "${var.name}_${var.owner}"
  role = "${aws_iam_role.cluster_member.name}"
  policy = "${template_file.iam_policy.rendered}"
}

resource "aws_iam_instance_profile" "cluster_member" {
  lifecycle {
    create_before_destroy = true
  }
  name = "${var.name}_${var.owner}"
  roles = ["${aws_iam_role.cluster_member.name}"]
}
