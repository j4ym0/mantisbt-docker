FROM php:apache

EXPOSE 80

RUN apt-get update -y && \
	apt-get install --no-install-recommends -y wget zlib1g-dev libpng-dev libonig-dev && \
	cd /tmp && \
	docker-php-ext-install mysqli && \
	docker-php-ext-install gd && \
	docker-php-ext-install mbstring && \
	docker-php-ext-install fileinfo && \
	wget -O mantisbt.tar.gz https://sourceforge.net/projects/mantisbt/files/mantis-stable/2.27.1/mantisbt-2.27.1.tar.gz/download && \
	tar xvzf mantisbt.tar.gz -C /tmp && \
	mv mantisbt-*/* /var/www/html && \
	chown -R www-data:www-data /var/www/html && \
	apt-get -y remove wget && \
	apt-get -y autoremove && \
	rm -rf /*.zip /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
	mkdir /config && \
	cp /var/www/html/config/* /config && \
	rm -rf /var/www/html/config && \
	ln -s /config /var/www/html	&& \
	chown -R www-data:www-data /config


COPY ./httpd.conf /etc/apache2/sites-available/000-default.conf

COPY ./php.ini $PHP_INI_DIR/conf.d/

COPY ./entrypoint.sh /

RUN chmod 500 /entrypoint.sh

ENTRYPOINT /entrypoint.sh
