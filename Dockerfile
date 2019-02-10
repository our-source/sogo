FROM debian:stretch

MAINTAINER Johan Smits "johan.smits@leftclick.eu"

RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends apt-transport-https ca-certificates dirmngr gnupg && \
    apt-key adv --keyserver keys.gnupg.net --recv-key 0x810273C4 && \
    echo "deb https://packages.inverse.ca/SOGo/nightly/4/debian/ stretch stretch" > /etc/apt/sources.list.d/SOGo.list && \
    apt-get update -qq && \
    apt-get install -yq --no-install-recommends apache2 sogo sope4.9-gdl1-postgresql sope4.9-gdl1-mysql supervisor memcached memcached && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    a2enmod headers proxy proxy_http rewrite ssl && \
    usermod --home /srv/lib/sogo sogo && \
    ln -s /etc/apache2/conf.d/SOGo.conf /etc/apache2/conf-enabled/SOGo.conf && \
    sed -i -e 's/#RedirectMatch \^\/\$ https:\/\/mail.yourdomain.com\/SOGo/RedirectMatch \^\/\$ \/SOGo/' /etc/apache2/conf-enabled/SOGo.conf && \
    sed -i -e 's/^-l.*/-l localhost/' /etc/memcached.conf

EXPOSE 80 443

COPY etc /etc

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
