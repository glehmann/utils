#!/bin/bash

case "$1" in
    -h|--hdlist)
	LIST=hdlist.cz
	;;
    *)
	LIST=synthesis.hdlist.cz
esac

VERSION=current

urpmi.addmedia -q --update main http://voxel.jouy.inra.fr/mdk/$VERSION/i586/media/main/ with media_info/$LIST
urpmi.addmedia -q --update contrib http://voxel.jouy.inra.fr/mdk/$VERSION/i586/media/contrib with media_info/$LIST
urpmi.addmedia -q --update jpackage http://voxel.jouy.inra.fr/mdk/$VERSION/i586/media/jpackage with media_info/$LIST
urpmi.addmedia -q --update updates http://voxel.jouy.inra.fr/mdk/$VERSION/main_updates/ with media_info/$LIST
urpmi.addmedia -q --update comm http://voxel.jouy.inra.fr/mdk/$VERSION/comm/ with media_info/$LIST
urpmi.addmedia -q --update bdr http://voxel.jouy.inra.fr/mdk/$VERSION/bdr with media_info/$LIST
urpmi.addmedia -q --update plf-free http://voxel.jouy.inra.fr/mdk/$VERSION/plf/free/ with $LIST
urpmi.addmedia -q --update plf-non-free http://voxel.jouy.inra.fr/mdk/$VERSION/plf/non-free/ with $LIST
