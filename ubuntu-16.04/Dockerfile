# vim:set ft=dockerfile:
FROM library/ubuntu:16.04
MAINTAINER 04n0
# set debian frontend to noninteractive during the build process
ARG DEBIAN_FRONTEND=noninteractive
# set erlang version
ARG ERLANG_VERSION="20.0"
# set version for coffeescript, node-gyp
ARG COFFEESCRIPT_VERSION="1.12"
ARG NODEGYP_VERSION="3.6.2"
# packages
ARG BUILD_PACKAGES="apt-transport-https ca-certificates curl git make sudo \
                    gcc libwxgtk3.0-0v5 imagemagick"
ARG ELIXIR_PACKAGES="erlang-dev erlang-ssl erlang-parsetools elixir"
ARG YARN_PACKAGES="bower coffee-script@${COFFEESCRIPT_VERSION} \
                  node-gyp@${NODEGYP_VERSION}"
# apply utf-8 locales
RUN apt-get update && \
    apt-get install locales && \
    locale-gen en_US.utf8 && \
    locale -a && \
    dpkg-reconfigure locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# set environment variables for build process
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm
# update repositories and perform upgrade of packages, if applicable
RUN apt-get update && \
    apt-get upgrade -y && \
# install necessary packages for build process
    apt-get install -y --no-install-recommends ${BUILD_PACKAGES} && \
# do cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
# install erlang, elixir, nodejs, yarn repos
RUN cd /tmp && \
# add erlang repo
    curl -sO https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i /tmp/erlang-solutions_1.0_all.deb && \
    curl -sO https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
    apt-key add erlang_solutions.asc && \
# add yarn repo
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
# add nodejs repo
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    rm /tmp/* && \
    apt-get update && \
# install erlang latest
    apt-get install -y esl-erlang && \
# install latest elixir and dependencies
    apt-get install -y ${ELIXIR_PACKAGES} && \
# install nodejs, yarn
    apt-get install -y nodejs yarn && \
# install Node.js applications for build process - bower,coffeescript,node-gyp
    yarn global add ${YARN_PACKAGES} && \
# cleanup
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
# copy buildscript and make it executable
COPY example/build.sh /build.sh
RUN chmod 755 /build.sh
# change workdir
WORKDIR /
# run build process when you execute container
CMD ["/build.sh"]
