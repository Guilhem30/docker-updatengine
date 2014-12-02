#!/bin/sh
[ "${autostart}" = 'true' ] || exit 0

. /etc/apache2/envvars
exec apache2 -D FOREGROUND
