# 1 - specification des plugins requis : 
terraform{
  required_version = ">= 1.0.0" # version minimum de terraform
  required_providers {
    vmworkstation = {
      #le connecteur pour piloter VMware workstation pro 
      source = "elsudano/vmworkstation"
      version = "2.0.1"
    }
  }
}

# 2 - configuration de la connection à l'API de vmware workstation pro 
# provider "vmworkstation" configure les parametres de connnexion à l'API REST locale (vmrest.exe) de VMware workstation pro
provider "vmworkstation" {
  username = var.vmrest_user    # nom d'utilisateur de l'API
  password = var.vmrest_password # mot de passe de l'API
  endpoint = var.vmrest_url  # url locale de l'API Rest
  https = false # le protocole http est utilisé
  debug = "none" # pas de logs de debug inutiles dans le console 
}
