locals {
  network_name = "psn-playground-network"
}


resource "google_compute_network" "primary" {
  name = local.network_name
}