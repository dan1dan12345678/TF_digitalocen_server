variable "do_token" {
  type      = string
  default   = ""
  sensitive = true
}

variable "kube_config_path" {
  description = "Path to the kube config file"
  type        = string
  default     = "/etc/kubernetes/admin.conf"
}






#######
variable "argo_namespace" {
  description = "The name of the namespace for ArgoCD deployments"
  type        = string
  default     = "argocd" # Optional: Provide a default value or omit this line to require explicit value input
}

