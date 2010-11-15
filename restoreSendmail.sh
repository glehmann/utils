#!/usr/bin/bash

echo restoring sendmail on $HOSTNAME
/usr/ccs/bin/m4 -D_CF_DIR_=/etc/mail/cf/ /etc/mail/cf/m4/cf.m4 /etc/mail/sendmail.m4 > /etc/mail/sendmail.cf
svcadm restart sendmail-client smtp:sendmail
echo test sendmail $HOSTNAME | mailx -s "$HOSTNAME" root


if [ -n "`zoneadm list | grep '^global$'`" ]; then
  for h in `zoneadm list | grep -v '^global$'`; do
    zlogin $h /usr/local/bin/restoreSendmail.sh
  done
fi
