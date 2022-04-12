terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

# Create a container.
# See (https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container)
resource "docker_container" "container1" {
  image             = "centos:7"
  name              = "container1"
  must_run          = true
  rm                = true
  tty               = true # Keeps the container alive
}
resource "docker_container" "container2" {
  image             = "centos:7"
  name              = "container2"
  must_run          = true
  rm                = true
  tty               = true # Keeps the container alive
  ports {
    internal = 80
    external = 8080
  }
}

# Create inventory file in yml format
# See (https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)
#
# You can also manually create this file in ini format as seen in many Ansible tutorials.
resource "local_file" "inventory_file" {
  content = yamlencode({
    all : {
      vars : { ansible_connection : "docker" }
      hosts : {
        container1 : {}
      }
      children : {
        webservers : {
          hosts : {
            container2 : {}
          }
        }
      }
    }
  })
  filename = "inventory.yml"

  # We can optionally ping the hosts that this inventory describes to validate our inventory file.
  provisioner "local-exec" {
    command = "ansible all -m ping -i '${self.filename}'"
  }
}