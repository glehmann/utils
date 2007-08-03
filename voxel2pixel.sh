#!/bin/sh -x
#
# Script d'archivage des donnees sur pixel
# 
#


DEST_DIR=pixel::/backup/voxel/archives
SNAP_DIR=/root/home-snap

removeSnapshot() {
  lvremove --force /dev/data/snap || warn "Erreur lors de la suppression du snapshot"
}

removeMountPoint() {
  umount $SNAP_DIR || warn "Erreur lors du demontage du snapshot"
}


# les procedures d'erreur

warn() {
  SUBJECT="Alerte: Echec sauvegarde sur voxel."
  TO="gaetan.lehmann@jouy.inra.fr christophe.caron@jouy.inra.fr"
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
  rdiff-backup --check-destination-dir $DEST_DIR
  error "rdiff-backup a echoue"
}




# necessaire pour le snapshot lvm
modprobe dm_snapshot || error "Impossible de charger le module dm_snapshot"

# creation du snapshot avece 10G de tampon
lvcreate --size 10G --snapshot --name snap /dev/data/home || error "Erreur lors de la creation du snapshot"

# creation d'un repertoire et montage du snapshot
mkdir -p $SNAP_DIR
mount /dev/data/snap $SNAP_DIR  || mountFailed

# la sauvegarde
rdiff-backup \
   -v 5 \
   --ssh-no-compression \
   --exclude $SNAP_DIR/darcs/ \
   --exclude $SNAP_DIR/kitware/ \
   --exclude $SNAP_DIR/lost+found/ \
   --exclude $SNAP_DIR/TT_DB/ \
   --exclude-regexp '.*/non archive/.*' \
   $SNAP_DIR \
   $DEST_DIR \
|| backupFailed

# demontage du snapshot et suppression du repertoire
removeMountPoint 

# suppression du snapshot
# --force est necessaire pour que lvremove ne demandre pas de confirmation
removeSnapshot 

