# ansible-terraform-playground
A simple template for working with Terraform and Ansible to provision containers on your local machine

## Quickstart
```shell
# Create the containers
terraform -chdir=infra init
terraform -chdir=infra apply

# Save the inventory
terraform -chdir=infra output -raw ansible_inventory > inventory.yml

# Ping the hosts defined by the inventory file.
ansible all -i inventory.yml -m ping

# Run a playbook
ansible-playbook -i inventory.yml site.yml
```