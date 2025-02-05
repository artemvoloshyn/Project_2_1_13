variable "aws_region" {
  type        = string
  description = "region"
}

variable "cidr" {
  type        = string
  description = "for vpc"

}

variable "environment" {
  type        = string
  description = "value"
  default     = "presented"

}

variable "publicCIDR" {
  type        = string
  description = "value"

}

variable "public1CIDR" {
  type        = string
  description = "value"

}

variable "privateCIDR" {
  type        = string
  description = "value"

}

variable "private1CIDR" {
  type        = string
  description = "value"

}

variable "availability_zone" {
  type        = string
  description = "value"

}

variable "availability1_zone" {
  type        = string
  description = "value"

}

variable "security_group_name" {
  type        = string
  description = "Security group name"
}
variable "private_subnet_security_group_name" {
  type        = string
  description = "Private security group name"
}

variable "security_group_description" {
  type        = string
  description = "Security group description"
}

variable "private_subnet_security_group_description" {
  type        = string
  description = "Private_security group description"
}


variable "allowed_ports" {
  type        = list(any)
  description = "List of allowed ports"
  # default     = ["80", "22", "443", "8080", "8000", "8001"]
}

variable "private_subnet_allowed_ports" {
  type        = list(any)
  description = "List of allowed ports"
  # default     = ["80", "22", "443", "8080", "8000", "8001", "6379", "5432"]
}

variable "instance_type" {
  type        = string
  description = "value"
}

variable "postgresql_db_name" {
  type        = string
  description = "value"
}

variable "postgresql_user_name" {
  type        = string
  description = "value"
}

variable "postgresql_password_value" {
  type        = string
  description = "value"
}


variable "aws_s3_bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "index_html_source" {
  type        = string
  description = "Path to index.html file to upload to S3"
}

variable "config_json_source" {
  type        = string
  description = "Path to config.json file to upload to S3  "
}

variable "aws_user_account_id" {
  type        = string
  description = "AWS user account ID number"
}

variable "whitelist_locations" {
  type        = list(any)
  description = "Locations from which access is allowed"
}

variable "cpu_frontend" {
  type        = string
  description = "value"

}

variable "cpu_rds" {
  type        = string
  description = "value"

}

variable "cpu_redis" {
  type        = string
  description = "value"

}

variable "ram_rds" {
  type        = string
  description = "value"

}

variable "ram_redis" {
  type        = string
  description = "value"

}

variable "ram_frontend" {
  type        = string
  description = "value"

}

variable "ecs_cluster_name" {
  type        = string
  description = "value"

}

