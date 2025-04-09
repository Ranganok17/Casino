variable "env" {
  description = "Environment name (dev or prod)"
  type        = string
  default     = "prod"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "CasinoDevOpsTest"
    Environment = "prod"
  }
}
