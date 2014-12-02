# docker-updatengine


A docker image with Updatengine using SQLite

[Updatengine]: http://www.updatengine.com/


## Container Creation / Running
docker run --name updatengine -d -E "SERVER_IP=192.168.0.100" -p 1979:1979 guilhem30/updatengine

The admin password is visible in 'docker logs updatengine'

