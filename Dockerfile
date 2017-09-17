FROM ubuntu:16.04
ENV SRC_DIR /usr/local/src/monero
WORKDIR $SRC_DIR

RUN apt-get update && apt-get install -y \
 git build-essential bsdmainutils libunbound-dev \
 libevent-dev libgtest-dev libboost-dev curl wget

WORKDIR /usr/local/monero

RUN wget https://downloads.getmonero.org/cli/linux64 -O monero.tar.bz2

RUN tar -jvxf monero.tar.bz2 --strip-components=2

# Contains the blockchain
VOLUME /root/.bitmonero

# Generate your wallet via accessing the container and run:
# cd /wallet
# monero-wallet-cli
VOLUME /wallet

ENV LOG_LEVEL 0
ENV P2P_BIND_IP 0.0.0.0
ENV P2P_BIND_PORT 18080
ENV RPC_BIND_IP 127.0.0.1
ENV RPC_BIND_PORT 18081

EXPOSE 18080
EXPOSE 18081

# CMD ./monerod --log-level=$LOG_LEVEL --p2p-bind-ip=$P2P_BIND_IP --p2p-bind-port=$P2P_BIND_PORT --rpc-bind-ip=$RPC_BIND_IP --rpc-bind-port=$RPC_BIND_PORT