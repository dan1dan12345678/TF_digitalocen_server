variable "do_token" {
  type      = string
  default   = "dop_v1_7f222afb0f33b52ad6ca86a4f7cb6a99f858fb99b53315bdd9bac3cf12ac32aa"
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

