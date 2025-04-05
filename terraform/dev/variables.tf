variable "env" {
  description = "Environment name (dev or prod)"
  type        = string
  default     = "dev"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "CasinoDevOpsTest"
    Environment = "dev"
  }
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS"
  type        = list(string)
}
