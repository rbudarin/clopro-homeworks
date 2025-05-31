resource "yandex_kms_symmetric_key" "key-a" {
  name              = var.kms_key_name
  description       = var.kms_key_description
  default_algorithm = var.kms_algorithm
  rotation_period   = var.kms_rotation_period
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = var.static_key_description
}

resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "${var.student_name}-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  acl        = var.my_acl
  max_size   = var.bucket_max_size

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = var.sse_algorithm
      }
    }
  }
}

resource "yandex_storage_object" "image_encrypted" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = yandex_storage_bucket.bucket.bucket
  key           = var.img_name
  source        = var.img_name
  acl           = var.my_acl
  content_type  = var.object_content_type
}
