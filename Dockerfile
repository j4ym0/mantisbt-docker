FROM php:apache

EXPOSE 80

VOLUME /config

RUN apt-get update -y && \
	apt-get install --no-install-recommends -y libpng-dev libonig-dev && \
	cd /tmp && \
	docker-php-ext-install mysqli && \
	docker-php-ext-install gd && \
	docker-php-ext-install mbstring && \
	docker-php-ext-install fileinfo && \
	curl -sSL https://github.com/mantisbt/mantisbt/archive/release-2.24.4.tar.gz | tar xzC /tmp && \
	mv mantisbt-*/* /var/www/html && \
	chown -R www-data:www-data /var/www/html && \
	apt-get -y autoremove && \
	rm -rf /*.zip /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
	cp /var/www/html/config/* /config && \
	rm -rf /var/www/html/config && \
	ln -s /config /var/www/html	&& \
	chown -R www-data:www-data /config


COPY ./httpd.conf /etc/apache2/sites-available/000-default.conf

COPY ./php.ini $PHP_INI_DIR/conf.d/

COPY ./cleanup.sh ./entrypoint.sh /

RUN chmod 500 /entrypoint.sh /cleanup.sh

ENTRYPOINT /entrypoint.sh
