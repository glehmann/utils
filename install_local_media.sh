#!/bin/sh

urpmi.addmedia --update plf-non-free /var/www/html/mdk/current/plf/non-free
urpmi.addmedia --update plf-free /var/www/html/mdk/current/plf/free
urpmi.addmedia --update contrib /var/www/html/mdk/current/i586/media/contrib
urpmi.addmedia --update comm /var/www/html/mdk/10.1/comm
urpmi.addmedia --update bdr /var/www/html/mdk/bdr/RPMS
urpmi.addmedia --update updates /var/www/html/mdk/current/main_updates
urpmi.addmedia --update main /var/www/html/mdk/current/i586/media/main
urpmi.addmedia --update jpackage /var/www/html/mdk/current/i586/media/jpackage
