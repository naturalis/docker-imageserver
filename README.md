docker-imageserver
=====================
docker-compose definition for deployment of nginx based image server


Docker-compose
--------------

This puppet script configures a complete docker-compose setup for an imageserver Which
consists of:

 - nginx
 - traefik

It is started using Foreman which creates:

 - .env file
 - traefik.toml
 - .transip.key
 - acme.json

The puppet script generates:

running docker-compose project

Result
------
Working nginx imageserver. 

Limitations
-----------
This has been tested on Ubuntu 18.04LTS 
