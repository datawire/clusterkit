// outputs.tf

output "cluster_launch_config_name" {
  value = "${aws_autoscaling_group.cluster.launch_configuration}"
}

output "cluster_autoscaling_group_name" {
  value = "${aws_autoscaling_group.cluster.name}"
}