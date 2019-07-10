FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf

COPY conf /etc/nginx
COPY scripts /opt/scripts
COPY docker-entrypoint.sh /usr/bin

ENTRYPOINT /usr/bin/docker-entrypoint.sh
