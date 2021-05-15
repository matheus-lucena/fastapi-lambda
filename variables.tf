variable "project_name" {
  description = "The name of the project"
  default="NAME_OF_PROJECT"
}

variable "memory" {
  description = "The memory size of the lambda function"
  default=256
}

variable "collection_id" {
  default = "COLLECTION_GENERATED_CLI"
}
