# NAT instance
resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"
  hostname = "nat-instance"
  zone     = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/ya_machine.pub")}"
  }
}


# Public instance
resource "yandex_compute_instance" "public-vm" {
  name        = "public-instance"
  hostname    = "public-instance"
  platform_id = var.platform
  zone        = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd826honb8s0i1jtt6cg"
    }
  }
    scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/ya_machine.pub")}"
  }

    provisioner "file" {
    source      = "~/.ssh/ya_machine"
    destination = "/home/ubuntu/.ssh/ya_machine"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/ya_machine"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/ya_machine")
    host        = self.network_interface[0].nat_ip_address
  }
}

# Private instance
resource "yandex_compute_instance" "private-vm" {
  name        = "private-instance"
  hostname    = "private-instance"
  platform_id = var.platform
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" 
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/ya_machine.pub")}"
  }
}
