// ansible.tf

resource "template_file" "ec2_ini" {
  lifecycle {
    create_before_destroy = true
  }
  template = "${file("${path.root}/etc/templates/ec2.ini.tpl")}"

  vars {
    region = "${var.region}"
    cluster_fqn = "${var.cluster_fqn}"
  }
}

resource "null_resource" "ec2_ini" {
  provisioner "local-exec" {
    command = "echo '${template_file.ec2_ini.rendered}' > ${path.root}/etc/inventory/ec2.ini"
  }
  triggers {
    template = "${template_file.ec2_ini.rendered}"
  }
}