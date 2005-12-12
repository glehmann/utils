#!/bin/sh -x
#
# Script d'archivage des donnees sur pixel
# 
#
export RSYNC_RSH=ssh

RSYNC=/usr/bin/rsync

DAY=`date +%d-%m-%Y`


REMOTE_CURRENT_DIR=/backup/voxel/current
REMOTE_INC_DIR=/backup/voxel/incremental


ssh pixel mkdir -p $REMOTE_CURRENT_DIR $REMOTE_INC_DIR

cd /home

echo -n "" > /root/excludelist

# construction de la liste de fichiers a exclure
for exfile in `find . -name .backupexclude -type f` ; do 
    DIR=`dirname $exfile`
    cd $DIR
    for f in `cat .backupexclude` ; do
        echo $DIR/$f >> /root/excludelist
    done
    cd -
done


$RSYNC --exclude-from=/root/excludelist \
    -aq \
    --exclude darcs \
    --exclude kitware \
    --exclude mirror \
    --delete \
    --delete-excluded \
    --backup \
    --backup-dir=${REMOTE_INC_DIR}/${DAY} \
    * \
    pixel:${REMOTE_CURRENT_DIR} \
|| echo 'il faut vite faire quelquechose !' | mail -s 'Alerte: rsync a echoue sur voxel' gaetan.lehmann@jouy.inra.fr christophe.caron@jouy.inra.fr

# compression de la difference et sauvegarde de la liste de fichiers
(
ssh pixel \
 cd $REMOTE_INC_DIR/$DAY \; \
 tar cjf ../${DAY}.tar.bz2 \* \; \
 rm -rf $REMOTE_INC_DIR/$DAY \; \
 cd $REMOTE_CURRENT_DIR \; \
 find \> $REMOTE_INC_DIR/${DAY}.list \; \
 bzip2 $REMOTE_INC_DIR/${DAY}.list \; \
) || echo 'il faut vite faire quelquechose !' | mail -s 'Alerte: la sauvegarde des fichiers supprimes a echoue sur voxel' gaetan.lehmann@jouy.inra.fr christophe.caron@jouy.inra.fr
#





