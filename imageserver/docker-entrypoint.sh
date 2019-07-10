#!/bin/bash


if ! [[ -e /var/www/imageserver/resize.php ]] ; then
ln -s /opt/scripts/resize.php /var/www/html/resize.php
fi

if ! [[ -e /var/www/imageserver/upload_log.php ]] ; then
ln -s /opt/scripts/resize.php /var/www/html/upload_log.php
fi

nginx -g "daemon off;"