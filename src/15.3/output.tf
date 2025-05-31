# Result
output "pic-url" {
  value = "https://${yandex_storage_bucket.bucket.bucket_domain_name}/${yandex_storage_object.image_encrypted.key}"
  description = "Bucket picture address"
}
