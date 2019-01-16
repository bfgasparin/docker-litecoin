FROM ubuntu:xenial
MAINTAINER Bruno Gasparin <bfgasparin@gmail.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /litecoin

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} litecoin \
	&& useradd -u ${USER_ID} -g litecoin -s /bin/bash -m -d /litecoin litecoin

RUN apt-get update && apt-get install -y wget && \
    wget https://download.litecoin.org/litecoin-0.16.3/linux/litecoin-0.16.3-x86_64-linux-gnu.tar.gz && \
    tar -zvxf litecoin-0.16.3-x86_64-linux-gnu.tar.gz && \
    mv litecoin-0.16.3/* /litecoin && \
    rm -R litecoin-0.16.3 && rm litecoin-0.16.3-x86_64-linux-gnu.tar.gz && \
    cp /litecoin/bin/* /usr/local/bin

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y \
		ca-certificates \
		wget \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./bin /usr/local/bin

VOLUME ["/litecoin"]

EXPOSE 9332 9333 19332 19333

WORKDIR /litecoin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["btc_oneshot"]
