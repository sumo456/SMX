#!/bin/bash

# Definim les carpetes a fer backup
carpetes=(Pictures)

# Obtenim la data actual amb el format desitjat
data=$(date +%Y%m%d)

# Creem el directori de destinació amb la data actual
desti="/temporal/backup_$data"
mkdir -p "$desti"

# Comprimim els arxius abans d'enviar-los al servidor de backups
zip -r "$desti/backup_comprimit_$data.zip" "$HOME/${carpetes[@]}"

# Creem el fitxer de contrasenya per al xifrat amb la clau de xifrat desitjada
echo "clau_de_xifrat" > "$desti/pass.txt"

# Xifrem els arxius comprimits amb gpg
gpg --batch -c --passphrase-file pass.txt $desti/backup_comprimit_$data.zip

# Copiem els arxius xifrats al servidor de backup amb scp
scp -i /home/usuari/.ssh/id_rsa $desti/backup_comprimit_$data.zip.gpg backup-daniel-salvador@172.16.24.196:../../backup

# Mostrem un missatge de confirmació del backup realitzat
echo "Backup realitzat daniel $(date)"

# Eliminem els fitxers temporals (opcional)
rm -f "$desti/backup_comprimit_$data.zip" "$desti/backup_comprimit_$data.zip.gpg" "$desti/pass.txt"
