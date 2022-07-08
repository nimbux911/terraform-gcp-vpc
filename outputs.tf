output "subnet_name" {
  value = google_compute_subnetwork.subnet[0].name
}

output "vpc_name" {
  value = google_compute_network.vpc_network[0].name
}

output "vpc_id" {
  value = google_compute_network.vpc_network[0].id
}
