variable "DOCKER_TLS_CERTDIR" {
  type        = string
  default     = "/certs"
}

variable "DOCKER_HOST" {
  type        = string
  default     = "tcp://docker:2376"
  # default     = "jenkins-docker:2376"
  # default     = "unix:///var/run/docker.sock"
}

variable "DOCKER_CERT_PATH" {
  type        = string
  default     = "/certs/client"
}

variable "DOCKER_TLS_VERIFY" {
  type        = number
  default     = 1
}

variable "JAVA_OPTS" {
  type        = string
  default     = "-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true"
}