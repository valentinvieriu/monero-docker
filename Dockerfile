###
# Build image
###
# Inspired from https://hub.docker.com/r/frolvlad/alpine-glibc/~/dockerfile/

FROM alpine:3.6 AS build

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.26-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

ENV LANG=C.UTF-8

###
# Run image
###
# FROM alpine:3.6
FROM build

LABEL maintainer="valentinvieriu <valentinvieriu@users.noreply.github.com>"
LABEL description="MoneroD in Docker. Full node."

ARG MONERO_VERSION=0.11.1.0
ENV MONERO_VERSION $MONERO_VERSION
ARG MONERO_SHA=6581506f8a030d8d50b38744ba7144f2765c9028d18d990beb316e13655ab248
ENV MONERO_SHA $MONERO_SHA

WORKDIR /root
RUN apk add --no-cache --virtual .build-deps \
    bzip2 \
    ca-certificates \
    curl \
    && curl -SLO "https://downloads.getmonero.org/cli/monero-linux-x64-v$MONERO_VERSION.tar.bz2" \
    && echo "$MONERO_SHA  monero-linux-x64-v$MONERO_VERSION.tar.bz2" | sha256sum -c - \
    && tar -jxvf "monero-linux-x64-v$MONERO_VERSION.tar.bz2" \
    && rm "monero-linux-x64-v$MONERO_VERSION.tar.bz2" \
    # && mv monero-*/monerod /bin/monerod \
    && chmod a+x monero-*/* && mv monero-*/* /bin/ \
    && rm -r monero-* \
    && apk del .build-deps

# blockchain loaction
VOLUME /root/.bitmonero

EXPOSE 18080 18081

ENTRYPOINT ["monerod"]
CMD ["--rpc-bind-ip=0.0.0.0", "--confirm-external-bind", "--fast-block-sync=1"]