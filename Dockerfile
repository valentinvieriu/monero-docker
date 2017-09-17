FROM ubuntu:16.04

MAINTAINER valentinvieriu <valentinvieriu@users.noreply.github.com>
LABEL description="MoneroD in Docker. Full node."

WORKDIR /root

RUN apt-get update \
    && apt-get -y --no-install-recommends install bzip2 ca-certificates curl \
    && curl -L -O https://downloads.getmonero.org/cli/monero-linux-x64-v0.11.0.0.tar.bz2 \
    && echo 'fa7742c822f3c966aa842bf20a9920803d690d9db02033d9b397cefc7cc07ff4  monero-linux-x64-v0.11.0.0.tar.bz2' | sha256sum -c - \
    && tar -jxvf monero-linux-x64-v0.11.0.0.tar.bz2 \
    && rm monero-linux-x64-v0.11.0.0.tar.bz2 \
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