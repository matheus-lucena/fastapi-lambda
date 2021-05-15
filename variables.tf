variable "project_name" {
  description = "The name of the project"
  default="teste-faceee"
}

variable "memory" {
  description = "The memory size of the lambda function"
  default=256
}

variable "collection_id" {
  default = "collection_teste"
}
