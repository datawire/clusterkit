# ClusterKit

A toolkit to help a developer setup a useful cluster for working on EC2. Can be made to deploy any kind of artifact with Ansible and arbitrary additional infrastructure can be added as necessary.

## Requirements

- You need [Ansible 2.x](http://docs.ansible.com/ansible/intro_installation.html) and [Terraform](https://www.terraform.io/downloads.html) to use this tool kit.
- You will need some basic knowledge of how Ansible works and how to write playbooks and roles in order to orchestrate your cluster. The Ansible docs are fairly comprehensive in this regard http://docs.ansible.com/ansible/intro.html.

## Setup

1. Edit terraform.tfvars as needed. At a minimum a developer should update the `ssh_key` variable and also modify the `label` variable with something more relevant.
2. Edit ansible.cfg and modify `private_key_file` to point at the file system path where the private key associated with the public key indicated by the variable `ssh_key` is located.

## Usage

### Deploy

```bash
./tf get 
./tf apply
```

### Destroy

```bash
./tf destroy
```

### Marking one or more nodes unhealthy

The script `bin/set-unhealthy` can mark one or all instances as unhealthy which means they will be replaced by the AWS autoscaling scheduler. This is useful for testing failures and other things.

### Orchestration

Describing how to use Ansible is beyond the scope of this document, but in general the idea is to write Roles and put them in the roles/ directory and then wire the rolls into the deploy.yml file as needed.

## Variables

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

## License 

Datawire Discovery is open-source software licensed under **Apache 2.0**. Please see [LICENSE](LICENSE) for further details.