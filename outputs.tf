// outputs.tf

output "cluster_launch_config_name" {
  value = "${module.cluster.cluster_launch_config_name}"
}

output "cluster_autoscaling_group_name" {
  value = "${module.cluster.cluster_autoscaling_group_name}"
}