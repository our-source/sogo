FROM debian:buster

RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends apt-transport-https ca-certificates dirmngr gnupg2 && \
    mkdir ~/.gnupg && \
    echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf && \
    (apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-key 0x810273C4 || apt-key adv --keyserver ipv4.pool.sks-keyservers.net --recv-key 0x810273C4) && \
    echo "deb https://packages.inverse.ca/SOGo/nightly/5/debian/ buster buster" > /etc/apt/sources.list.d/SOGo.list && \
    apt-get update -qq && \
    apt-get install -yq --no-install-recommends apache2 sogo sope4.9-gdl1-postgresql sope4.9-gdl1-mysql supervisor memcached memcached && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    a2enmod headers proxy proxy_http rewrite ssl && \
    usermod --home /srv/lib/sogo sogo && \
    sed -i -e 's/#RedirectMatch \^\/\$ https:\/\/mail.yourdomain.com\/SOGo/RedirectMatch \^\/\$ \/SOGo/' /etc/apache2/conf-enabled/SOGo.conf && \
    mkdir -p /var/run/memcached/ && \
    chown memcache:memcache /var/run/memcached

EXPOSE 80 443

COPY etc /etc

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
