module "vpc" {
  source = "./modules/google-vpc-network"
}

module "gke" {
  source = "./modules/google-kubernetes-engine"
}
