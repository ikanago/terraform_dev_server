terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.88.0"
    }
  }
}

provider "google" {
  project     = "dev-env-310511"
  region      = "us-west1"
}

resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "dev_env" {
  name = "dev-env-${random_id.instance_id.hex}"
  machine_type = "e2-micro"
  zone = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external ip address
    }
  }
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh-from-iap"
  network = "default"
  direction = "INGRESS"
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}
