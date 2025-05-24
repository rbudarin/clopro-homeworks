output "nat_ip_addresses" {
  description = "NAT IP addresses of all VMs"
  value = {
    private-vm  = yandex_compute_instance.private-vm.network_interface[0].ip_address
    public-vm   = yandex_compute_instance.public-vm.network_interface[0].nat_ip_address
  }
} 
