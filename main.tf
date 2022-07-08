###	VPC configuration  
##########################################
locals {
  count = var.existing ? 0 : 1
}
resource "google_compute_network" "vpc_network" {
  count                   = local.count
  name                    = var.vpc_name
  routing_mode            = var.routing_mode
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count                    = local.count
  name                     = var.subnet_name
  region                   = var.subnet_region
  ip_cidr_range            = var.subnet_cidr
  description              = var.subnet_description
  network                  = google_compute_network.vpc_network[0].self_link
  private_ip_google_access = true
}

resource "google_compute_firewall" "iap" {
  count   = local.count
  name    = "allow-ingress-from-iap"
  network = google_compute_network.vpc_network[0].name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-ingress-from-iap"]
}

// Router
resource "google_compute_router" "router" {
  count   = local.count
  name    = "${var.environment}-router"
  region  = google_compute_subnetwork.subnet[0].region
  network = google_compute_network.vpc_network[0].id

  bgp {
    asn = 64514
  }
}

// Nat instance
resource "google_compute_router_nat" "nat" {
  count                              = local.count
  name                               = "${var.environment}-router-nat"
  router                             = google_compute_router.router[0].name
  region                             = google_compute_router.router[0].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

// Private Connection Services

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "backend-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network[0].id
  depends_on    = [google_compute_network.vpc_network]

}

resource "google_service_networking_connection" "backend_connection" {
  network                 = google_compute_network.vpc_network[0].id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
