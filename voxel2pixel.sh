#!/bin/sh -x
#
# Script d'archivage des donnees sur pixel
# 
#

rdiff-backup \
   -v 5
   --ssh-no-compression \
   --exclude /home/darcs/ \
   --exclude /home/kitware/ \
   --exclude /home/lost+found/ \
   --exclude /home/TT_DB/ \
   /home pixel::/backup/voxel/archives \
|| echo 'il faut vite faire quelquechose !' | mail -s 'Alerte: rdiff-backup a echoue sur voxel' gaetan.lehmann@jouy.inra.fr christophe.caron@jouy.inra.fr




