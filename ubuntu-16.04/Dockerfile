# vim:set ft=dockerfile:
FROM library/ubuntu:16.04
MAINTAINER 04n0
# set debian frontend to noninteractive during the build process
ARG DEBIAN_FRONTEND=noninteractive
# set erlang version
ARG ERLANG_VERSION="19.3"
# set coffeescript version
ARG COFFEESCRIPT_VERSION="1.12"
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
    apt-get install -y curl git make sudo gcc libwxgtk3.0-0v5 imagemagick && \
# do cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
# install erlang, elixir and nodejs 6+
RUN cd /tmp && \
    curl -O https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i /tmp/erlang-solutions_1.0_all.deb && \
    curl -O https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
    apt-key add erlang_solutions.asc && \
    rm /tmp/* && \
    apt-get update && \
# install erlang latest
    apt-get install -y esl-erlang && \
# install latest elixir and dependencies
    apt-get install -y erlang-dev erlang-ssl erlang-parsetools elixir && \
# install Node.js (>= 6.0.0) and NPM in order to satisfy brunch.io dependencies
# see http://www.phoenixframework.org/docs/installation#section-node-js-5-0-0-
# see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get install -y nodejs && \
# install Node.js applications for build process - bower, coffee script, node-gyp
    npm install -g bower && \
    npm install -g coffee-script@${COFFEESCRIPT_VERSION} && \
    npm install -g node-gyp@3.6.0 && \
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
