# 1 - declaration de l'utilisateur de l'api 
variable "vmrest_user" {
  type        = string
  description = "Nom de l'utilisateur configuré pour l'API REST de VMware workstation"
  default = "admin"    #valeur par defaut 
}

# 2 - declaration du mot de passe de l'utilisateur de l'api (masqué ! )
variable "vmrest_password" {
  type        = string
  description = "Mot de passe configuré pour l'API REST de VMware workstation"
  sensitive = true    #masque le mdp dans les logs de console
}
# 3 - declaration de l'adresse ip de l'api REST 
variable "vmrest_url" {
  type        = string
  description = "Url locale de l'API REST de VMware workstation"
  default = "http://127.0.0.1:8697/api"
}

# 4 - declaration de l'id unique de la VM modèle ( ubuntu-base)
variable "base_vm_id" {
  type        = string
  description = "Id unique de la VM modèle (ubuntu-base)"
}

# 5 - declaration du dossier de stackage des machines cibles 
variable "vm_base_dir" {
  type        = string
  description = "Chemin local du dossier de stockage des machines virtuelles "
  default = "C:\\Users\\farah\\Virtual Machines"
}