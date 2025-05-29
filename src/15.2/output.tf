# Result
output "pic-url" {
  value = "https://${yandex_storage_bucket.bucket.bucket_domain_name}/${yandex_storage_object.image.key}"
  description = "Bucket picture address"
}

output "nlb-address" {
  value = yandex_lb_network_load_balancer.nlb.listener.*.external_address_spec[0].*.address
  description = "Network LB address"
}
