variable "ami_value" {
    description = "value for the ami"
    
}

variable "instance_type_value" {
    description = "value for the instance_type"
}

variable "name_prefix_value" {
    description = "value for the name_prefix"
}

variable "asg_min_size_value" {
  description = "value for the min_size"
}

variable "asg_max_size_value" {
  description = "value for the max_size"
}

variable "listen_port_value" {
  description = "value for the port that the app is listen to"
}

variable "protocol_value" {
  description = "value for the protocol that the app is working with"
}

variable "subnets_value" {
   description = "value for the public subnets"
}

variable "security_group_instance_id_value" {
   description = "value for the security group id for instance"
}

variable "security_group_lb_id_value" {
   description = "value for the security group id for lb"
}

variable "vpc_id_value" {
  description = "value for the vpc_id"
}