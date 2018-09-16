FROM krutpong/apache-php7.2-fpm
MAINTAINER krutpong "krutpong@gmail.com"

RUN apt-get install -y wget
RUN apt-get install build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 -y
# install phantomjs
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
RUN ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
RUN phantomjs --version

# install casperjs
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm install -g casperjs
RUN casperjs --version


EXPOSE 80
EXPOSE 443
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD config/index.html /var/www/index.html
ADD config/index.php /var/www/index.php
COPY config/apache2.conf /etc/apache2/apache2.conf

COPY config/apache_enable.sh apache_enable.sh
RUN chmod 744 apache_enable.sh


#VOLUME ["/var/lib/mysql"]
VOLUME ["/var/www","/var/www"]
RUN service php7.2-fpm start
CMD ["/usr/bin/supervisord"]








