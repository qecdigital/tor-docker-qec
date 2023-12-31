# vim:set ft=dockerfile:
FROM alpine:latest

LABEL org.opencontainers.image.authors="\"QEC Digital Alliance\" <tech@qec.digital>"

RUN apk --update \
        --allow-untrusted \
        --repository http://dl-4.alpinelinux.org/alpine/edge/community/ \
        add \
          tor \
          torsocks \
          python3 \
          python3-dev \
          py3-pip \
          build-base \
&&  apk --update \
        --allow-untrusted \
        --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ \
        add \
          obfs4proxy \
&&  pip install nyx --no-cache-dir \
&&  rm -rf /var/cache/apk/* \
           /tmp/* \
           /var/tmp/*

RUN sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc \
&&  sed -i "s|#%include /etc/torrc.d/\*.conf|%include /etc/torrc.d/\*.conf|g" /etc/tor/torrc \
&&  mkdir -p /etc/torrc.d


VOLUME ["/etc/torrc.d"]
VOLUME ["/var/lib/tor"]

USER tor

# TODO: add ulimits

ADD --chmod=755 docker-entrypoint.sh /usr/local/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/docker-entrypoint.sh"]
