variable "location" {
  description = "The location where resources are created"
  default     = "WestUS2"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
  default     = "myWinImgBuilderRG"
}

variable "image_name" {
  description = "The name for the image"
  default     = "myWinBuilderImage"
}

variable "run_output_name" {
  description = "Run output name"
  default     = "myWinBuilder"
}
