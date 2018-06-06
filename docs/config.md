litecoind config tuning
======================

You can use environment variables to customize config ([see docker run environment options](https://docs.docker.com/engine/reference/run/#/env-environment-variables)):

        docker run -v litecoind-data:/litecoin --name=litecoind-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            -e DISABLEWALLET=1 \
            -e PRINTTOCONSOLE=1 \
            -e RPCUSER=mysecretrpcuser \
            -e RPCPASSWORD=mysecretrpcpassword \
            brunogasparin/litecoind

Or you can use your very own config file like that:

        docker run -v litecoind-data:/litecoin --name=litecoind-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            -v /etc/mylitecoin.conf:/litecoin/.litecoin/litecoin.conf \
            brunogasparin/litecoind
