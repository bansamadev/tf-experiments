module "jenkins_server" {
  source = "./jenkins"

}

module "jenkins_nodes" {
  source        = "./jenkins_nodes"
  jenkins_nodes = 2
}
