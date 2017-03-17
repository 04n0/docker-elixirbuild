# vim:set ft=dockerfile:
FROM alpine:edge

MAINTAINER 04n0

ARG ERLANG_VERSION="19.3"
ARG ELIXIR_VERSION="1.4.2"
ARG NODEGYP_VERSION="3.6.0"
ARG COFFEESCRIPT_VERSION="1.12"

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
    apk --no-cache --update upgrade && \
# install Erlang/OTP deps
    apk add --no-cache \
      ca-certificates \
      openssl-dev \
      ncurses-dev \
      unixodbc-dev \
      zlib-dev \
      git make unzip g++ curl && \
# install Erlang/OTP build deps
    apk add --no-cache --virtual .erlang-build \
    git autoconf build-base perl-dev && \
# shallow clone Erlang/OTP in ${ERLANG_VERSION} version
    export ERL_TOP=/tmp/erlang-build && \
    mkdir -p ${ERL_TOP} && cd ${ERL_TOP} && \
    git clone -b OTP-${ERLANG_VERSION} --single-branch --depth 1 https://github.com/erlang/otp.git . && \
# erlang/OTP build env
    export PATH=$ERL_TOP/bin:$PATH && \
    export CPPFlAGS="-D_BSD_SOURCE $CPPFLAGS" && \
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
# install elixir
    cd /tmp && \
    curl -LO https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip && \
    unzip Precompiled.zip && \
    mkdir -p /usr/local/bin && mv bin/* /usr/local/bin && \
    mkdir -p /usr/local/man && mv man/* /usr/local/man && \
    mkdir -p /usr/local/lib && mv lib/* /usr/local/lib && \
# install hex and rebar
    /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force

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
COPY ../example/build.sh /build.sh
RUN chmod 755 /build.sh
# change workdir
WORKDIR /
# run build process when you execute container
CMD ["/build.sh"]