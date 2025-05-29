# Main Network
resource "yandex_vpc_network" "network" {
  name = var.net_name
}
# Public subnet
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = var.yc_region
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
