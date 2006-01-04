#!/bin/sh -x
#
# Script d'archivage des donnees sur pixel
# 
#


# necessaire pour le snapshot lvm
modprobe dm_snapshot

# creation du snapshot avece 10G de tampon
lvcreate --size 10G --snapshot --name snap /dev/data/home

# creation d'un repertoire et montage du snapshot
mkdir -p /root/home-snap
mount /dev/data/snap /root/home-snap/

# la sauvegarde
rdiff-backup \
   -v 5 \
   --ssh-no-compression \
   --exclude /root/home-snap/darcs/ \
   --exclude /root/home-snap/kitware/ \
   --exclude /root/home-snap/lost+found/ \
   --exclude /root/home-snap/TT_DB/ \
   /root/home-snap/ pixel::/backup/voxel/archives \
|| echo 'il faut vite faire quelquechose !' | mail -s 'Alerte: rdiff-backup a echoue sur voxel' gaetan.lehmann@jouy.inra.fr christophe.caron@jouy.inra.fr

# demontage du snapshot et suppression du repertoire
umount /root/home-snap
rmdir /root/home-snap

# suppression du snapshot
# --force est necessaire pour que lvremove ne demandre pas de confirmation
lvremove --force /dev/data/snap

