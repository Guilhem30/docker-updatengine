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
	sed "s/##updatengine_server_ip##/$SERVER_IP/g"  updatengine/settings.py.model_mysql > updatengine/settings.py
	sed -i "s/##database_name##/$DATABASE_NAME/g"  updatengine/settings.py
	sed -i "s/##database_user_name##/$DATABASE_USER/g"  updatengine/settings.py
	sed -i "s/##database_user_password##/$DATABASE_PASSWORD/g"  updatengine/settings.py
	sed -i "s/# 'HOST': '',/ 'HOST': 'mysql-container', /g"  updatengine/settings.py



	./manage.py syncdb --noinput
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('$ADMIN_USERNAME', '$ADMIN_MAIL', '$ADMIN_PASS')" | ./manage.py shell
	./manage.py migrate
	./manage.py loaddata initial_data/configuration_initial_data.yaml
	./manage.py loaddata initial_data/groups_initial_data.yaml
	chown -R www-data:www-data updatengine/static/
	chown -R www-data:www-data updatengine/media/
	patch -p1 /usr/local/lib/python2.7/dist-packages/django/forms/models.py requirements/patchs/patch-django_1.6.2_17118.patch
	echo "ADMIN_PASS=$ADMIN_PASS"
fi

