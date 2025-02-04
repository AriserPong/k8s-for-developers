terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.60" # or newer
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

#############################
# Standard GKE Cluster
#############################
resource "google_container_cluster" "gke_standard" {
  name                = var.standard_cluster_name
  location            = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  network    = "default"
  subnetwork = "default"
}

# Primary Node Pool (Regular)
resource "google_container_node_pool" "primary_pool" {
  name       = "primary-pool"
  location   = google_container_cluster.gke_standard.location
  cluster    = google_container_cluster.gke_standard.name
  node_count = 1

  # autoscaling {
  #   min_node_count = 1
  #   max_node_count = 3
  # }

  node_config {
    machine_type = "e2-medium"
    labels = {
      "pool" = "primary"
    }
    tags = ["primary-pool"]

    # taint {
    #   key    = "primary"
    #   value  = "true"
    #   effect = "NO_SCHEDULE"  # Prevents scheduling unless tolerated
    # }
  }
}

# Preemptible Node Pool
resource "google_container_node_pool" "preemptible_pool" {
  name       = "preemptible-pool"
  location   = google_container_cluster.gke_standard.location
  cluster    = google_container_cluster.gke_standard.name
  node_count = 0

  autoscaling {
    min_node_count = 0
    max_node_count = 4
  }

  node_config {
    machine_type = "e2-medium"
    spot  = true
    labels = {
      "pool" = "preemptible"
    }
    tags = ["preemptible-pool"]

    # taint {
    #   key    = "preemptible"
    #   value  = "true"
    #   effect = "NO_SCHEDULE"  # Prevents scheduling unless tolerated
    # }
  }
}

#############################
# Autopilot GKE Cluster
#############################
resource "google_container_cluster" "gke_autopilot" {
  name      = var.autopilot_cluster_name
  location  = var.region

  # Enable Autopilot
  enable_autopilot = true

  release_channel {
    channel = "REGULAR"
  }

  network    = "default"
  subnetwork = "default"
}
