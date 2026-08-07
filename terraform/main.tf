# deploiement de la machine virtuelle ELK-Vault ( le 1er noeud)
resource "vmworkstation_virtual_machine" "elk-vault" {
  sourceid = var.base_vm_id #on utilise l'id de la vm de base 
  denomination = "elk-vault" #nom de la vm
  path = "${var.vm_base_dir}\\elk-vault\\elk-vault.vmx" #chemin de la vm
  processors = 2
  memory = 3072 
  state = "on" #on active automatiquement la vm apres la creation 
}

#deploiement du Kubernetes Master ( noeud 2 )
resource "vmworkstation_virtual_machine" "k8s-master" {
  sourceid = var.base_vm_id
  denomination = "k8s-master"
  path = "${var.vm_base_dir}\\k8s-master\\k8s-master.vmx"
  processors = 2
  memory = 2300
  state = "on"
}
#deploiement du Kubernetes Worker ( noeud 3 )
resource "vmworkstation_virtual_machine" "k8s-worker" {
  sourceid = var.base_vm_id
  denomination = "k8s-worker"
  path = "${var.vm_base_dir}\\k8s-worker\\k8s-worker.vmx"
  processors = 1
  memory = 4096
  state = "on"
}