# Kubernetes Enterprise Platform ☸️🔒📊

Une plateforme d'orchestration de conteneurs d'entreprise hautement disponible, sécurisée et supervisée, déployée de façon automatisée en mode **Infrastructure as Code (IaC)**. 

Ce projet a été réalisé dans le cadre d'un projet de fin d'études/stage pour héberger de manière sécurisée et résiliente l'application web full-stack **WokMaster** (Angular, Spring Boot, MySQL).

---

## 🎯 Architecture Cible de la Plateforme

L'infrastructure s'exécute localement sur **VMware Workstation Pro** et est composée de 3 nœuds Ubuntu Server provisionnés par **Terraform** :

1.  **`elk-vault`** (`192.168.233.189`) : Serveur de sécurité (HashiCorp Vault) et de supervision (Elasticsearch, Kibana).
2.  **`k8s-master`** (`192.168.233.188`) : Plan de contrôle Kubernetes (Control Plane).
3.  **`k8s-worker`** (`192.168.233.190`) : Exécution des conteneurs applicatifs (Pods Angular, Spring Boot, MySQL et agents Beats).

---

## 📂 Structure du Projet

```text
├── terraform/                # Recettes de déploiement IaC (VMware Workstation)
│   ├── providers.tf          # Déclaration du provider et connecteur API
│   ├── variables.tf          # Déclaration des variables d'infrastructure
│   ├── terraform.tfvars      # Valeurs privées (exclu du Git via .gitignore)
│   └── main.tf               # Définition des 3 VMs et de leurs ressources
├── kubernetes/               # Manifestes YAML de déploiement des applications
│   ├── mysql-deploy.yaml     # Déploiement de la base MySQL avec stockage hostPath
│   ├── backend-deploy.yaml    # Déploiement de l'API Spring Boot (Java 17)
│   └── frontend-deploy.yaml   # Déploiement d'Angular servi par Nginx
├── scripts/                  # Scripts shell de configuration et d'automatisation
│   ├── install_k8s.sh        # Installation automatisée de containerd et Kubernetes
│   ├── install_elk.sh        # Installation d'Elasticsearch, Kibana et Vault
│   ├── backup-db.sh          # Script de sauvegarde à chaud (mysqldump) de MySQL
│   ├── restore-db.sh         # Script de restauration à chaud de MySQL
│   └── get_vms.ps1           # Script PowerShell d'interrogation de l'API VMware
├── .gitignore                # Fichier d'exclusion de sécurité pour Git
├── README.md                 # Guide de démarrage (ce document)
└── documentation_projet.md   # Documentation technique détaillée du projet
```

---

## 🛠️ Prérequis

*   **Système d'exploitation Hôte :** Windows 10/11 (16 Go RAM recommandé).
*   **Hyperviseur :** VMware Workstation Pro.
*   **Outils d'infrastructure :** Terraform, Git, CLI `kubectl`.
*   **Réseau :** Configurer l'emplacement par défaut des VMs VMware en dehors de tout dossier synchronisé par cloud (ex: OneDrive).

---

## 🚀 Guide de Démarrage Rapide (Quick Start)

### Étape 1 : Activer l'API REST de VMware sur Windows
Ouvrez une console PowerShell en mode Administrateur :
```powershell
cd "C:\Program Files (x86)\VMware\VMware Workstation"
# Démarrer le serveur API local
.\vmrest.exe -p 8697
```

### Étape 2 : Provisionner les VMs avec Terraform
Ouvrez un terminal classique dans le dossier `/terraform` du projet :
```bash
terraform init
terraform plan
# Déploiement séquentiel obligatoire pour éviter les verrous de fichiers
terraform apply -parallelism=1
```

### Étape 3 : Démarrer et déverrouiller Vault (Security)
À chaque démarrage, connectez-vous en SSH sur la VM **`elk-vault`** (`192.168.233.189`) et déverrouillez le coffre-fort :
```bash
export VAULT_SKIP_VERIFY=true
vault operator unseal # (À répéter 3 fois avec vos clés de déverrouillage)
```

### Étape 4 : Déployer l'application sur Kubernetes
Depuis votre machine Master (`k8s-master`), appliquez les fichiers YAML :
```bash
kubectl apply -f kubernetes/mysql-deploy.yaml
kubectl apply -f kubernetes/backend-deploy.yaml
kubectl apply -f kubernetes/frontend-deploy.yaml
```

### Étape 5 : Exposer le site sur Internet avec ngrok
Sur votre PC Windows, ouvrez le tunnel de partage :
```cmd
ngrok http http://192.168.233.190:30081 --url VOTRE_DOMAINE_NGROK.ngrok-free.dev
```
Vous pouvez maintenant vous connecter à l'application depuis votre mobile ou n'importe quel ordinateur externe !

---

## 💾 Sauvegarde & Restauration (Volume MySQL)

Les scripts d'automatisation des sauvegardes sont situés dans `/scripts`.

*   **Lancer une sauvegarde à chaud :**
    ```bash
    ./scripts/backup-db.sh
    ```
    *Le fichier `.sql` horodaté sera enregistré dans `/home/farah/backups/`.*

*   **Restaurer un état précédent :**
    ```bash
    ./scripts/restore-db.sh /home/farah/backups/nom_du_fichier_sauvegarde.sql
    ```

---

## 📊 Observability (Centralisation des logs)

Pour visualiser en temps réel les logs et les statistiques de performance de vos conteneurs :
1.  Connectez-vous à Kibana depuis votre navigateur Windows : **`http://192.168.233.189:5601`**.
2.  Allez dans **Analytics ➔ Discover** et filtrez par `kubernetes.container.name : "backend"` pour analyser le comportement de votre API REST.
