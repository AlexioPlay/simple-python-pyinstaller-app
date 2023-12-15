terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "docker_dind" {
  name         = "docker:dind"
  keep_locally = false
}

resource "docker_image" "myjenkins-blueocean" {
  name         = "myjenkins-blueocean:2.426.2-1"
  keep_locally = false
}

resource "docker_container" "jenkins-docker" {
  image = docker_image.docker_dind.image_id
  name  = "jenkins-docker"
  privileged = true
  ports {
    internal = 3000
    external = 3000
  }
  ports {
    internal = 5000
    external = 5000
  }
  ports {
    internal = 2376
    external = 2376
  }
  env = [
    "DOCKER_TLS_CERTDIR=${var.DOCKER_TLS_CERTDIR}"
  ]
  volumes {
    volume_name    = docker_volume.jenkins-docker-certs.name
    container_path = "/certs/client"
  }
  volumes {
    volume_name    = docker_volume.jenkins-data.name
    container_path = "/var/jenkins_home"
  }
  networks_advanced {
    name = docker_network.jenkins_network.name
  }
}

resource "docker_container" "jenkins-blueocean" {
  image = docker_image.myjenkins-blueocean.image_id
  name  = "jenkins-blueocean"
  restart = "on-failure"
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
  env = [
    "DOCKER_HOST=${var.DOCKER_HOST}",
    "DOCKER_CERT_PATH=${var.DOCKER_CERT_PATH}",
    "DOCKER_TLS_VERIFY=${var.DOCKER_TLS_VERIFY}",
    "JAVA_OPTS=${var.JAVA_OPTS}"
  ]
  volumes {
    volume_name    = docker_volume.jenkins-data.name
    container_path = "/var/jenkins_home"
  }
  volumes {
    volume_name    = docker_volume.jenkins-docker-certs.name
    container_path = "/certs/client"
    read_only  = true
  }
  volumes {
    volume_name    = docker_volume.homepath.name
    container_path = "/home"
    host_path      = "/User/alexa"
  }
  networks_advanced {
    name = docker_network.jenkins_network.name
  }
}

resource "docker_volume" "jenkins-docker-certs" {
  name = "jenkins-docker-certs"
}
resource "docker_volume" "jenkins-data" {
  name = "jenkins-data"
}
resource "docker_volume" "homepath" {
  name = "homepath"
}

resource "docker_network" "jenkins_network" {
  name = "jenkins_network"
}
