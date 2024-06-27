data "docker_registry_image" "jenkins_lts" {
  name = "jenkins/jenkins:lts-jdk17"

}

resource "docker_image" "jenkins_lts" {
  name          = data.docker_registry_image.jenkins_lts.name
  pull_triggers = [data.docker_registry_image.jenkins_lts.sha256_digest]
  keep_locally  = true
}

resource "docker_container" "jenkins_lts" {
  image   = docker_image.jenkins_lts.image_id
  name    = "jenkins-lts"
  restart = "on-failure"

  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
  volumes {
    container_path = "/var/jenkins_home"
    volume_name    = "jenkins_home"
  }
  volumes {
    container_path = "/usr/share/jenkins/ref/init.groovy.d/executors.groovy"
    host_path      = "${path.cwd}/executors.groovy"
  }
  volumes {
    container_path = "/usr/share/jenkins/ref/init.groovy.d/plugins.groovy"
    host_path      = "${path.cwd}/plugins.groovy"
  }
  volumes {
    container_path = "/usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state"
    host_path      = "${path.cwd}/jenkins.install.UpgradeWizard.state"
  }
}
