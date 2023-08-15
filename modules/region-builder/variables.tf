variable region {
  type = string
  default = "eu-central-1"
}

variable az_1 {
  type = string
  default = "eu-central-1a"
}

variable az_2 {
  type = string
  default = "eu-central-1b"
}

variable instance_type {
  type = string
  default = "t2.micro"
}

variable domain {
  type = string
}

variable scale_min {
  type = number
  default = 1
}


variable scale_max {
  type = number
  default = 1
}


variable scale_target {
  type = number
  default = 1
}

variable min_health {
  type = number
  default = 20
}

variable cpu_max {
  type = number
  default = 70
}


