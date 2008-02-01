#!/bin/bash -x
cd /tmp
cd /var/cache/httpd/
service httpd stop
/bin/ls /var/cache/httpd/ | xargs rm -rf
service httpd start
