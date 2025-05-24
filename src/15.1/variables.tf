variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "yc_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


variable "yc_cidr_public" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Public"
}
variable "yc_cidr_private" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "Private"
}

variable "net_name" {
  type        = string
  default     = "develop"
  description = "VPC network name"
}

variable "platform" {
  type        = string
  default     = "standard-v3"
  description = "WM Platform"
}
