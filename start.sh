#!/bin/bash

set -e
ADMIN_PASS=${ADMIN_PASS:-$(pwgen -s -1 16)}

cd  /var/www/UE-environment/updatengine-server/


[ "${autoconf}" = 'true' ] || exit 0
if [ -f updatengine/settings.py ]
then
	echo "Configuration Found, Loading it"
else
	echo "No configuration found, Creating it from the template"
	sed -i "s/^env_path/#env_path/g"  updatengine/wsgi.py
	sed -i "s/^activate_this/#activate_this/g"  updatengine/wsgi.py
	sed -i "s/^execfile/#execfile/g"  updatengine/wsgi.py
	sed "s/##updatengine_server_ip##/$SERVER_IP/g"  updatengine/settings.py.model_sqlite > updatengine/settings.py



	./manage.py syncdb --noinput
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('$ADMIN_USERNAME', '$ADMIN_MAIL', '$ADMIN_PASS')" | ./manage.py shell
	./manage.py migrate
	./manage.py loaddata initial_data/configuration_initial_data.yaml
	./manage.py loaddata initial_data/groups_initial_data.yaml
	chown -R www-data:www-data /var/www/UE-environment/updatengine-server/updatengine/static/
	chown -R www-data:www-data /var/www/UE-environment/updatengine-server/updatengine/media/
	echo "ADMIN_PASS=$ADMIN_PASS"
fi

