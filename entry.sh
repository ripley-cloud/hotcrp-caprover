#!/bin/sh

# Create database if necessary
php /checkAndCreateDatabase.php

# Configure SMTP settings based on environment
envsubst < /etc/msmtprc.template > /etc/msmtprc

# Start supervisord and services
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf