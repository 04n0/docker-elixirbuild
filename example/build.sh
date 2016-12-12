#!/usr/bin/env bash

# enable debug info ; exit on first issue
set -x
#set -e

MYAPP_BUILD_DIR="/build"
MYAPP_RELEASES_DIR="/releases"

#
echo "Updating system"
apt-get update && apt-get upgrade -y
echo "Building MyApp ${MIX_ENV} release"
echo "---"
# install hex package manager and rebar dependency tool
mix local.hex --force && mix local.rebar --force
#
cd ${MYAPP_BUILD_DIR}
# get hex package depndencies
mix deps.get
mix deps.compile
# install nodejs packages
cd ${MYAPP_BUILD_DIR}/apps/myapp_web/
npm install
# install bower packages
bower install --allow-root
# brunch - build a production folder
./node_modules/brunch/bin/brunch b -p
cd ${MYAPP_BUILD_DIR}
# compile applications
mix compile --env=${MIX_ENV} --verbose=verbose
# create phoenix digest for static and create a upgradable release
cd ${MYAPP_BUILD_DIR}/apps/myapp_web/
mix do phoenix.digest --env=${MIX_ENV} --verbose=verbose
cd ${MYAPP_BUILD_DIR}
mix release --env=${MIX_ENV} --verbose=verbose --upgrade
cd /
