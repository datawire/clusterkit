# ClusterKit

Toolkit to help a developer get setup with a useful cluster for working on EC2. Can be made to deploy any kind of artifact with Ansible and arbitrary additional infrastructure can be added as necessary.

# Requirements

* You need Ansible 2.x and Terraform to use this tool.

# Setup

1. Edit terraform.tfvars as needed. At a minimum a developer should update the `ssh_key` variable and also modify the `label` variable with something more relevant.
2. Edit ansible.cfg and modify `private_key_file` to point at the file system path where the private key associated with the public key indicated by the variable `ssh_key` is located.

# Usage

## Deploy

```bash
./tf get 
./tf apply
```

## Destroy

```bash
./tf destroy
```

# Variables

By default deployed cluster exposes a number of variables that can be modified to tweak behavior in terraform.tfvars.

| Variable              | Purpose                                         |
|-----------------------|-------------------------------------------------|
| cluster_image_id      | the AMI to deploy instances with.               | 
| cluster_instance_type | the EC2 instance to deploy.                     |
| cluster_min_size      | the minimum size of the deployed cluster.       | 
| cluster_max_size      | the maximum size of the deployed cluster.       |
| environment_type      | the operations environment.                     |
| environment_label     | the operations environments label.              |
| label                 | the label applied to your resources.            |
| region                | the AWS region to deploy into.                  |
| ssh_key               | the *name* of the SSH public key stored in AWS. |

# Utilities

The bin/ directory contains a number of useful utility scripts. 