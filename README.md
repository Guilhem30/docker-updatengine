# docker-updatengine


A docker image with Updatengine using MySQL / mariadb

[Updatengine]: http://www.updatengine.com/

## Run a database

<<<<<<< HEAD
## Container Creation / Running
docker run --name updatengine -d -e "SERVER_IP=192.168.0.100" -p 1979:1979 guilhem30/updatengine
=======
   docker run --name mydb -d bretif/mariadb

Then enter the database container with docker exec, ssh or another tool and prepare the dababase :

    mysqladmin -u root -p create updatengine
    mysql -u root -p -e "GRANT ALL PRIVILEGES ON updatengine.* TO 'updatengineuser' \
    IDENTIFIED by 'password' WITH GRANT OPTION;"
    mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
    
Restart the container with docker restart

## Run Updatengine
You need to set the right parameters / env variables

    docker run --name updatengine -d -p 1979:1979 --link mydb:mysql-container \
    -e "DATABASE_USER=updatengineuser" -e "DATABASE_PASSWORD=password" guilhem30/updatengine
>>>>>>> mysql

The admin password is visible in 'docker logs updatengine'

