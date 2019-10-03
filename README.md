docker-imageserver
=====================
docker-compose definition for deployment of nginx based image server


Docker-compose
--------------

This puppet script configures a complete docker-compose setup for an imageserver Which
consists of:

 - nginx
 - traefik 2

It is started using Foreman which creates:

 - .env file
 - traefik/traefik.toml

Configure puppet with adding cronjob entry:
*/15 * * * * /opt/composeproject/cronscript/copy_uploaded_files.sh >> /var/log/copy_uploaded_files.log

Configure puppet with adding logrotate entry for /var/log/copy_uploaded_files.log

Configure puppet base manifest with imageupload user and add authorised_keys 

The puppet script generates:

running docker-compose project

Result
------
Working nginx imageserver. 

Limitations
-----------
This has been tested on Ubuntu 18.04LTS 
