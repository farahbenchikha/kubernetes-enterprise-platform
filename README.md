# Kubernetes Enterprise Platform

Ce dossier contient tout le code source pour votre projet de déploiement de plateforme Kubernetes.

## Structure du projet recommandée
- `/terraform` : Fichiers de configuration Terraform pour le déploiement sur VMware.
- `/ansible` : (Optionnel) Playbooks pour automatiser la configuration interne des machines.
- `/kubernetes` : Fichiers YAML pour configurer les applications, secrets Vault et agents Filebeat sur le cluster.
- `/scripts` : Scripts shell d'aide à l'installation.

---
*Ce répertoire a été créé dans le dossier scratch de votre agent. Pour commencer à travailler, ouvrez ce dossier dans votre éditeur de code.*
