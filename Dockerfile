# Pinned to a PHP release with the php2shell fixes (CVE-2026-109618, CVE-2026-109619).
# Alpine's php83 packages lagged the fix, so this no longer builds on trafex/php-nginx.
FROM php:8.3.36-fpm-alpine3.24

USER root

RUN apk add --no-cache nginx supervisor curl msmtp gettext git icu-libs gmp libzip libpng \
 && apk add --no-cache --virtual .build-deps icu-dev gmp-dev libzip-dev libpng-dev \
 && docker-php-ext-install -j"$(nproc)" mysqli intl gmp zip gd \
 && apk del .build-deps

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN rm -rf /var/www/html
RUN chown -R nobody /var/www/

COPY config/msmtprc /etc/msmtprc.template
COPY config/msmtprc /etc/msmtprc
RUN chown nobody /etc/msmtprc
RUN ln -sf /usr/bin/msmtp /usr/bin/sendmail
RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail

COPY entry.sh /
RUN chmod +x /entry.sh

COPY config/php.ini $PHP_INI_DIR/conf.d/custom.ini
COPY config/nginx.conf /etc/nginx/nginx.conf
# zz-docker.conf would move the listener to TCP 9000; nginx expects the unix socket
RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf
COPY config/fpm-pool.conf /usr/local/etc/php-fpm.d/www.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chown -R nobody:nobody /run /var/lib/nginx /var/log/nginx

USER nobody
RUN git clone https://github.com/jon-bell/hotcrp /var/www/html
 
COPY options.php /var/www/html/conf/options.php
COPY checkAndCreateDatabase.php /

EXPOSE 8080

# run at container startup
ENTRYPOINT ["/entry.sh"]
