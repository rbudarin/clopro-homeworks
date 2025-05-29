# Service account for bucket
resource "yandex_iam_service_account" "s3-bucket" {
  name        = "s3-bucket-ca01"
  description = "service account for bucket"
}

# Role for service account
resource "yandex_resourcemanager_folder_iam_member" "s3-bucket" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.s3-bucket.id}"
}

# Keys for service account
resource "yandex_iam_service_account_static_access_key" "accesskey-bucket" {
  service_account_id = yandex_iam_service_account.s3-bucket.id
  description        = "static access key for object storage"
}

# Create bucket
resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.accesskey-bucket.access_key
  secret_key = yandex_iam_service_account_static_access_key.accesskey-bucket.secret_key
  bucket = "${var.student_name}-${formatdate("YYYYMMDD-hhmmss", timestamp())}" 

  max_size = 1073741824 # 1 Gb

  default_storage_class = "STANDARD"
  anonymous_access_flags {
    read = true
    list = false
  }
}

# Add picture in the bucket
resource "yandex_storage_object" "image" {
  access_key = yandex_iam_service_account_static_access_key.accesskey-bucket.access_key
  secret_key = yandex_iam_service_account_static_access_key.accesskey-bucket.secret_key
  bucket  = yandex_storage_bucket.bucket.bucket
  key     = "linux.png"
  source  = "./linux.png"
}
