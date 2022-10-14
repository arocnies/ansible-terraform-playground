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

output "ansible_inventory" {
  value = yamlencode({
    all : {
      vars : { ansible_connection : "docker" }
      hosts : {
        container1 : {}
      }
    }
  })
  description = "The Ansible inventory in yaml format"
}
