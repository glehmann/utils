#!/bin/sh -x
#
# Script d'archivage des donnees sur pixel
# 
#

DATE=`date +%F`

removeSnapshot() {
  ssh voxel lvremove --force /dev/data/snap || warn "Erreur lors de la suppression du snapshot"
}

removeMountPoint() {
  ssh voxel umount /mnt/home-snap || warn "Erreur lors du demontage du snapshot"
}

# les procedures d'erreur

warn() {
  SUBJECT="Alerte: Echec sauvegarde voxel ($DATE)."
  TO="gaetan.lehmann@jouy.inra.fr" # christophe.caron@jouy.inra.fr"
  echo "$1" | mail -s "$SUBJECT $1" $TO
}

error() {
  warn "$1"
  exit 1
}


mountFailed() {
  removeSnapshot
  error "Erreur lors du montage du snapshot"
}

backupFailed() {
  removeMountPoint
  removeSnapshot 
  rdiff-backup --check-destination-dir /data/voxel-images/
  error "rdiff-backup a echoue"
}




# necessaire pour le snapshot lvm
ssh voxel modprobe dm_snapshot || error "Impossible de charger le module dm_snapshot"

# creation du snapshot avec 10G de tampon
ssh voxel lvcreate --size 100G --snapshot --name snap /dev/data/home || error "Erreur lors de la creation du snapshot"

# creation d'un repertoire et montage du snapshot
ssh voxel mkdir -p /mnt/home-snap
ssh voxel chmod 700 /mnt/home-snap
ssh voxel mount -o ro /dev/data/snap /mnt/home-snap  || mountFailed

# la sauvegarde
rdiff-backup \
   -v 5 \
   --backup-mode \
   --ssh-no-compression \
   --exclude-device-files \
   --exclude-fifos \
   --exclude-regexp '.*/non archive/.*' \
   voxel::/mnt/home-snap/home/ \
   /data/voxel-images/ \
|| backupFailed
#   --exclude-sockets \

# copie du repertoire de backup sur voxel pour l'avoir en double
rsync -avH --delete /data/voxel-images/rdiff-backup-data voxel:/data/ || error "rsync a echoue."

# demontage du snapshot et suppression du repertoire
removeMountPoint 

# suppression du vieux snapshot
# --force est necessaire pour que lvremove ne demande pas de confirmation
ssh voxel lvremove --force /dev/data/home-backup || warn "Erreur lors de la suppression de l'ancien snapshot"

# et renommage du snapshot actuel
ssh voxel lvrename /dev/data/snap /dev/data/home-backup || error "Erreur lors du renommage du snapshot"
