variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
}
variable "s3_tags" {
  description = "s3 tags"
  type        = map(string)
  default     = {}
}
