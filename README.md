docker-monero        [![Docker Stars](https://img.shields.io/docker/stars/valentinvieriu/monero.svg)](https://hub.docker.com/r/valentinvieriu/monero/)        [![Docker Pulls](https://img.shields.io/docker/pulls/valentinvieriu/monero.svg)](https://hub.docker.com/r/valentinvieriu/monero/)
=============

*[monero](http://monero.org) containers based on alpine-glibc*

Make sure you have a `.env` file in the root folder. Have a look at env.example to see what needs to be configured. This file is used by the docker-compose to bootstrap the services.

# Pulling
    docker pull valentinvieriu/monero

# Initial blockchain sync/bootstrap - we run it in the background because it might take some time
Make sure you download the blockchain `wget https://downloads.getmonero.org/blockchain.raw` in the shared colume folder `${ROOT_FOLDER}/data/export`
    docker-compose up -d import
# To export the blockchain - we run it in the background because it might take some time
    docker-compose up -d export
# Running the Daemon
    docker-compose up -d monero

# Checking the container status
    docker-compose log

    curl -X POST http://localhost:18081/json_rpc \
        -d '{"jsonrpc":"2.0","id":"test","method":"get_info"}' \
        -H "Content-Type: application/json" \
        -H "Accept:application/json"

# Using the wallet
    docker-compose run --rm wallet
