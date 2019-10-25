provider "google" {
  credentials = "${file("credentials/gcloud.json")}"
  project     = "htm-ctf"
  region      = "europe-west2"
  zone         = "europe-west2-a"
}

resource "random_id" "challenge" {
  byte_length = 8
}

resource "random_id" "ctfd" {
  byte_length = 8
}

resource "tls_private_key" "connection_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_network" "ctfd_network" {
  name = "ctfd-network"
}

resource "google_compute_firewall" "ctfd_firewall" {
  name    = "ctfd-firewall"
  network = "${google_compute_network.ctfd_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}

resource "google_compute_network" "challenge_network" {
  name = "challenge-network"
}

resource "google_compute_firewall" "challenge_firewall" {
  name    = "challenge-firewall"
  network = "${google_compute_network.challenge_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22", "2022", "8080"]
  }
}

resource "google_compute_address" "ctfd_ip" {
  name = "ctfd-address"
}

resource "google_compute_instance" "ctfd" {
  name         = "ctfd-${random_id.ctfd.hex}"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/ubuntu-1804-lts"
    }
  }

  scratch_disk {
  }

  provisioner "file" {
    source      = "scripts/ctfd.nginx"
    destination = "ctfd.nginx"

    connection {
      type = "ssh"
      user = "root"
      host = "${google_compute_address.ctfd_ip.address}"
      private_key = "${tls_private_key.connection_key.private_key_pem}"
    }
  }

  metadata_startup_script = "${file("./scripts/ctfd-setup.sh")}"

  network_interface {
    network = "${google_compute_network.ctfd_network.name}"
    access_config {
      nat_ip = "${google_compute_address.ctfd_ip.address}"
    }
  }

  metadata = {
    ssh-keys = "root:${tls_private_key.connection_key.public_key_openssh}"
  }
}

output "ctfd-ip" {
  value = "${google_compute_address.ctfd_ip.address}"
}

resource "google_compute_address" "challenge_ip" {
  name = "challenge-address"
}

resource "google_compute_instance" "challenge" {
  name         = "ctf-resources-${random_id.challenge.hex}"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/ubuntu-1804-lts"
    }
  }

  scratch_disk {
  }

  provisioner "file" {
    source      = "ctftool"
    destination = "/usr/bin/ctftool"

    connection {
      type = "ssh"
      user = "root"
      host = "${google_compute_address.challenge_ip.address}"
      private_key = "${tls_private_key.connection_key.private_key_pem}"
    }
  }

  provisioner "file" {
    source      = "challenges"
    destination = "/etc/ctf"

    connection {
      type = "ssh"
      user = "root"
      host = "${google_compute_address.challenge_ip.address}"
      private_key = "${tls_private_key.connection_key.private_key_pem}"
    }
  }

  metadata_startup_script = "${file("./scripts/challenge-setup.sh")}"

  network_interface {
    network = "${google_compute_network.challenge_network.name}"
    access_config {
      nat_ip = "${google_compute_address.challenge_ip.address}"
    }
  }

  metadata = {
    ssh-keys = "root:${tls_private_key.connection_key.public_key_openssh}"
  }
}

output "challenge-ip" {
  value = "${google_compute_address.challenge_ip.address}"
}
