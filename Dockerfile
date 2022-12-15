FROM trafex/php-nginx

USER root

RUN apk add --no-cache php81-zip php81-gmp msmtp gettext git

RUN rm -rf /var/www/html
RUN chown -R nobody /var/www/

COPY config/msmtprc /etc/msmtprc.template
COPY config/msmtprc /etc/msmtprc
RUN chown nobody /etc/msmtprc
RUN ln -sf /usr/bin/msmtp /usr/bin/sendmail
RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail

COPY entry.sh /
RUN chmod +x /entry.sh

COPY config/php.ini /etc/php81/conf.d/custom.ini
COPY config/nginx.conf /etc/nginx/nginx.conf

USER nobody
RUN git clone https://github.com/jon-bell/hotcrp /var/www/html
 
COPY options.php /var/www/html/conf/options.php
COPY checkAndCreateDatabase.php /

# run at container startup
ENTRYPOINT ["/entry.sh"]