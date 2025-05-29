# Service account for VM group
resource "yandex_iam_service_account" "sa-group" {
  name = "sa-group"
  description = "Service account for managing VM group"
}

# Add role editor for service account
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-group.id}"
}

# VM group
resource "yandex_compute_instance_group" "group-nlb" {
  name               = "group-nlb"
  folder_id          = var.folder_id
  service_account_id = "${yandex_iam_service_account.sa-group.id}"
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    
    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit" # LAMP image
     }
    }

    network_interface {
      network_id = "${yandex_vpc_network.network.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/ya_machine.pub")}"
      user-data = <<-EOT
        #!/bin/bash
        echo '<html><body><img src="http://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket_domain_name}/${yandex_storage_object.image.key}" alt="Image"></body></html>' > /var/www/html/index.html
        EOT
    }

    labels = {
      group = "group-nlb"
    }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_region]
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion   = 1
  }

  health_check {
    interval = 15
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
    http_options {
      path = "/"
      port = 80
    }
  }
  
  load_balancer {
    target_group_name = "target-nlb"
    target_group_description = "Target group for network balancer"
  }
}

