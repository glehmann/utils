#!/bin/bash

VERSION=current

LIST="synthesis.hdlist.cz"
WGET=""

while [ "$1" != "" ] ; do
    case "$1" in
        -H|--hdlist)
	    LIST=hdlist.cz
	    ;;
	-w|--wget)
	    WGET="--wget"
	    ;;
	-h|--help)
	    echo "-H --hdlist   installe les media avec les hdlist au lieu des synthesis"
	    echo "-w --wget     utilise wget pour recuperer les fichiers"
	    exit 1
    esac
    shift
done

urpmi.addmedia -q --update $WGET main http://voxel.jouy.inra.fr/mdk/$VERSION/i586/media/main/ with media_info/$LIST
urpmi.addmedia -q --update $WGET contrib http://voxel.jouy.inra.fr/mdk/$VERSION/i586/media/contrib with media_info/$LIST
urpmi.addmedia -q --update $WGET jpackage http://voxel.jouy.inra.fr/mdk/$VERSION/i586/media/jpackage with media_info/$LIST
urpmi.addmedia -q --update $WGET updates http://voxel.jouy.inra.fr/mdk/$VERSION/main_updates/ with media_info/$LIST
urpmi.addmedia -q --update $WGET comm http://voxel.jouy.inra.fr/mdk/$VERSION/comm/ with media_info/$LIST
urpmi.addmedia -q --update $WGET bdr http://voxel.jouy.inra.fr/mdk/$VERSION/bdr with media_info/$LIST
urpmi.addmedia -q --update $WGET plf-free http://voxel.jouy.inra.fr/mdk/$VERSION/plf/free/ with $LIST
urpmi.addmedia -q --update $WGET plf-non-free http://voxel.jouy.inra.fr/mdk/$VERSION/plf/non-free/ with $LIST
