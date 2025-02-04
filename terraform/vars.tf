variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "asia-southeast1"
  description = "Region to deploy GKE"
}

variable "standard_cluster_name" {
  type        = string
  default     = "pong-workshop-standard"
  description = "Name of the standard GKE cluster"
}

variable "autopilot_cluster_name" {
  type        = string
  default     = "pong-workshop-autopilot"
  description = "Name of the autopilot GKE cluster"
}
