FROM php:7.4-fpm

RUN docker-php-ext-install mysqli


RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev libzip-dev \
	libicu-dev libgmp-dev \
	re2c libmhash-dev \
	libmcrypt-dev file \
	poppler-utils git
	
RUN apt-get install -y -q --no-install-recommends \
		msmtp
		
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp 
RUN docker-php-ext-install gmp

RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN docker-php-ext-install zip

# And clean up the image

RUN rm -rf /var/lib/apt/lists/*


WORKDIR /srv/www/
RUN git clone https://github.com/kohler/hotcrp api
COPY options.php /srv/www/api/conf/options.php