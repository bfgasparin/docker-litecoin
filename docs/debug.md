# Debugging

## Things to Check

* RAM utilization -- litecoind is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The litecoin blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 40GB+ is necessary.

## Viewing litecoind Logs

    docker logs litecoind-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the litecoind node, but will not connect to already running containers or processes.

    docker run -v litecoind-data:/litecoin --rm -it brunogasparin/litecoind bash -l

You can also attach bash into running container to debug running litecoind

    docker exec -it litecoind-node bash -l


