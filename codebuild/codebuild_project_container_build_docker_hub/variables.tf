variable "image_name" {
  type        = string
  description = "Name of the image "
}

variable "image_tag"{
  type        = string
  description = "Image tag, eg; docker-image:1.0"

}

variable "build_context"{
  type        = string
  description = "Path to the folder to run docker build from"

}

variable "dockerfile"{
  type        = string
  description = " Path to the dockerfile"

}

variable "docker_hub_username"{
  type        = string
  description = "Dockerhub Username"

} 

variable "docker_hub_password"{
  type        = string
  description = "Dockerhub password"

}