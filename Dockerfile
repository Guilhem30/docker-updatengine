FROM        phusion/baseimage:0.9.15
MAINTAINER  <guilhem.berna@gmail.com>

RUN apt-get update && apt-get -yq install apache2 libapache2-mod-wsgi python-pip \
libxml2-dev libxslt-dev python-dev libmysqlclient-dev git-core pwgen

ENV autoconf true
ENV autostart true
ENV SERVER_IP 10.1.1.127
ENV ADMIN_USERNAME admin
ENV ADMIN_MAIL admin@example.com
ENV DATABASE_NAME updatengine
ENV DATABASE_USER updatengine
ENV DATABASE_PASSWORD updatengine

RUN mkdir /var/www/UE-environment
WORKDIR /var/www/UE-environment
RUN git clone https://github.com/updatengine/updatengine-server.git

RUN pip install --upgrade distribute
RUN pip install --upgrade setuptools
RUN pip install -r updatengine-server/requirements/pip-packages.txt

RUN mkdir -p /etc/my_init.d
COPY start.sh /etc/my_init.d/setup.sh
RUN mkdir /etc/service/apache2
COPY run_apache.sh /etc/service/apache2/run

RUN cp /var/www/UE-environment/updatengine-server/requirements/apache-updatengine.conf /etc/apache2/sites-available/apache-updatengine.conf
RUN a2ensite apache-updatengine.conf

# Add my public keys
ADD pubkeys /tmp/pubkeys
RUN cat /tmp/pubkeys/*.pub >> /root/.ssh/authorized_keys && rm -rf /tmp/pubkeys/
EXPOSE 22

ENTRYPOINT ["/sbin/my_init"]
EXPOSE 1979



