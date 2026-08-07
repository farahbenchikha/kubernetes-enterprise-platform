# ==============================================================================
# 1. LECTURE DES IDENTIFIANTS DEPUIS LE FICHIER TFVARS
# ==============================================================================
# On lit le fichier terraform.tfvars ligne par ligne
$tfvars = Get-Content -Path "C:\Users\farah\kubernetes-enterprise-platform\terraform\terraform.tfvars"
$user = ""
$pass = ""
$url = ""

# Pour chaque ligne du fichier, on utilise des expressions régulières (-match)
# pour extraire ce qui est écrit entre guillemets ( ) et l'enregistrer dans nos variables.
foreach ($line in $tfvars) {
    if ($line -match 'vmrest_user\s*=\s*"(.*)"') { $user = $Matches[1] }
    if ($line -match 'vmrest_password\s*=\s*"(.*)"') { $pass = $Matches[1] }
    if ($line -match 'vmrest_url\s*=\s*"(.*)"') { $url = $Matches[1] }
}

# ==============================================================================
# 2. PRÉPARATION DE LA SÉCURITÉ (AUTHENTIFICATION BASIC)
# ==============================================================================
Write-Host "Connexion à $url avec l'utilisateur '$user'..."

# L'API de VMware exige que l'identifiant et le mot de passe soient fusionnés
# sous la forme "user:password" et encodés au format Base64 (standard HTTP).
$pair = $user + ":" + $pass
$bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)

# On prépare l'en-tête (Header) de la requête HTTP
$headers = @{ 
    Authorization = "Basic $base64"                  # Clé de sécurité
    Accept        = "application/vnd.vmware.v1+json" # On indique à VMware qu'on veut du format JSON
}

# ==============================================================================
# 3. INTERROGATION DE L'API VMWARE & AFFICHAGE
# ==============================================================================
try {
    # Invoke-RestMethod envoie une requête web (GET) à l'API de VMware (adresse + "/vms")
    $vms = Invoke-RestMethod -Uri "$url/vms" -Headers $headers -Method Get
    
    # Si ça fonctionne, on affiche un message vert de succès
    Write-Host "Machines trouvées :" -ForegroundColor Green
    
    # On met en forme le résultat sous forme de tableau (id, chemin du fichier .vmx, et nom de la VM)
    $vms | Format-Table -Property id, path, denomination
} catch {
    # Si la connexion échoue (mauvais mot de passe, API éteinte, etc.), on affiche l'erreur
    Write-Error "Erreur lors de la connexion à l'API de VMware : $_"
}