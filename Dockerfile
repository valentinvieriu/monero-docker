FROM ubuntu:16.04

MAINTAINER valentinvieriu <valentinvieriu@users.noreply.github.com>
LABEL description="MoneroD in Docker. Full node."

ARG MONERO_VERSION=0.11.1.0
ENV MONERO_VERSION $MONERO_VERSION
ARG MONERO_SHA=6581506f8a030d8d50b38744ba7144f2765c9028d18d990beb316e13655ab248
ENV MONERO_SHA $MONERO_SHA

WORKDIR /root
RUN apt-get update \
    && apt-get -y --no-install-recommends install bzip2 ca-certificates curl \
    && curl -SLO "https://downloads.getmonero.org/cli/monero-linux-x64-v$MONERO_VERSION.tar.bz2" \
    && echo "$MONERO_SHA  monero-linux-x64-v$MONERO_VERSION.tar.bz2" | sha256sum -c - \
    && tar -jxvf "monero-linux-x64-v$MONERO_VERSION.tar.bz2" \
    && rm "monero-linux-x64-v$MONERO_VERSION.tar.bz2" \
    && mv monero-*/monerod /usr/local/bin/monerod \
    && chmod a+x /usr/local/bin/monerod \
    && rm -r monero-* \
    && apt-get -y remove bzip2 ca-certificates curl  \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

# blockchain loaction
VOLUME /root/.bitmonero

EXPOSE 18080 18081

ENTRYPOINT ["monerod"]
CMD ["--rpc-bind-ip=0.0.0.0", "--confirm-external-bind", "--fast-block-sync=1"]