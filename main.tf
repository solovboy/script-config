terraform {
  required_providers {
    ycp = {
      source = "terraform.storage.cloud-preprod.yandex.net/yandex-cloud/ycp"
      # version = "0.20.0" # optional
    }
  }
  required_version = ">= 0.13"
}


provider "ycp" {
  token     = "t1.9eudmZ3Hy4uKjcjIzpiTzs6RlpGTze3rnZmdz87JjYvPlJ7Jz8fPzMiWy57l8_cXKSVp-e8iHxlu_d3z91dXImn57yIfGW79.frncNi0wHxA9Ih-WNs_REk-NgLQ_yed6QCBfgrmYcgghNaBh8_Kj6ReOVY239jQ20zdvVSEfXBJhGGCsfwXFDg"
  cloud_id  = "aoedo0ji1lgce9l91har"
  folder_id = "aoeja1qpdnpu6vf5qldq"
}

