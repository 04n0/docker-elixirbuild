# vim:set ft=dockerfile:
FROM alpine:edge

MAINTAINER 04n0

# 
ARG ERLANG_VERSION="19.3"
ARG ELIXIR_VERSION="1.4.2"
ARG NODEGYP_VERSION="3.6.0"
ARG COFFEESCRIPT_VERSION="1.12"

# erlang/OTP build env
ARG ERL_TOP=/tmp/erlang-build
ARG PATH=${ERL_TOP}/bin:${PATH}
ARG CPPFLAGS="-D_BSD_SOURCE $CPPFLAGS"

# image env variables
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    HOME=/build \
    TERM=xterm

RUN \
# create default user and home directory, set owner to default
    mkdir -p ${HOME} && \
    adduser -s /bin/sh -u 1001 -G root -h ${HOME} -S -D default && \
    chown -R 1001:0 ${HOME} && \
# upgrade Alpine and base packages
    apk upgrade --no-cache --update && \
# install build tools, utils and ERLANG/OTP build deps
    apk add --no-cache \
      unzip \
      coreutils \
      findutils \
      bash \
      git \
      curl \
      autoconf \
      build-base \
      make \
      g++ \
      ca-certificates \
      python2 \
      python2-dev \
      openssl-dev \
      ncurses-dev \
      perl-dev \
      unixodbc-dev \
      zlib-dev && \
    apk add --no-cache --virtual .erlang-build && \
# shallow clone Erlang/OTP in ${ERLANG_VERSION} version
    mkdir -p ${ERL_TOP} && cd ${ERL_TOP} && \
    git clone -b OTP-${ERLANG_VERSION} --single-branch --depth 1 https://github.com/erlang/otp.git . && \
# configure
    ./otp_build autoconf && \
    ./configure --prefix=/usr \
      --sysconfdir=/etc \
      --mandir=/usr/share/man \
      --infodir=/usr/share/info \
      --without-javac \
      --without-wx \
      --without-debugger \
      --without-observer \
      --without-jinterface \
      --without-common_test \
      --without-cosEvent\
      --without-cosEventDomain \
      --without-cosFileTransfer \
      --without-cosNotification \
      --without-cosProperty \
      --without-cosTime \
      --without-cosTransactions \
      --without-dialyzer \
      --without-et \
      --without-gs \
      --without-ic \
      --without-megaco \
      --without-orber \
      --without-percept \
      --without-typer \
      --enable-threads \
      --enable-shared-zlib \
      --enable-ssl=dynamic-ssl-lib \
      --enable-hipe && \
# build erlang
    make -j4 && make install && \
# cleanup
    apk del .erlang-build && \
    rm -rf ${ERL_TOP} && \
# update ca certificates
    update-ca-certificates --fresh

RUN \
# install elixir from github precompiled binary package
    cd /tmp && \
    curl -LO https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip && \
    unzip Precompiled.zip && \
    mkdir -p /usr/local/bin && mv bin/* /usr/local/bin && \
    mkdir -p /usr/local/man && mv man/* /usr/local/man && \
    mkdir -p /usr/local/lib && mv lib/* /usr/local/lib

RUN \
    cd $HOME && \
# install nodejs, bower, coffee script, node-gyp
    apk add --no-cache nodejs nodejs-npm yarn && \
    npm install -g bower && \
    npm install -g coffee-script@${COFFEESCRIPT_VERSION} && \
    npm install -g node-gyp@${NODEGYP_VERSION} && \
# cleanup
    rm -rf /tmp && \
    rm -rf /var/cache/apk/* 

# copy buildscript and make it executable
COPY example/build.sh /build.sh
RUN chmod 755 /build.sh
# change workdir
WORKDIR /
# run build process when you execute container
CMD ["/build.sh"]
