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
    Environment = var.env
  }
}
