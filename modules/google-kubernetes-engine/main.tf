locals {
  cluster_name            = "psn-playground"
  enable_preemtible       = false
  prevent_destroy_cluster = false
  node_count              = 1
}


resource "google_service_account" "gke_default_sa" {
  account_id   = "${local.cluster_name}-cluster-sa"
  display_name = "Service Account for ${local.cluster_name} GKE cluster."
}

resource "google_container_cluster" "primary" {
  name                = local.cluster_name
  location            = local.zone
  deletion_protection = local.prevent_destroy_cluster

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${local.cluster_name}-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = local.node_count

  node_config {
    preemptible  = local.enable_preemtible
    machine_type = local.machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_default_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}