#!/bin/env bash

## original source
## https://github.com/moby/moby/blob/master/contrib/mkimage-alpine.sh


set -e

[ "$(id -u)" -eq 0 ] || {
	printf >&2 '%s requires root\n' "$0"
	exit 1
}

usage() {
	printf >&2 '%s: [-r release] [-m mirror] [-s]  [-c additional repository]\n' "$0"
	exit 1
}

tmp() {
	TMP=$(mktemp -d ${TMPDIR:-/var/tmp}/alpine-docker-XXXXXXXXXX)
	ROOTFS=$(mktemp -d ${TMPDIR:-/var/tmp}/alpine-docker-rootfs-XXXXXXXXXX)
	trap 'rm -rf $TMP $ROOTFS' EXIT TERM INT
}

apkv() {
	curl -sSL $MAINREPO/$ARCH/APKINDEX.tar.gz | tar -Oxz |
		grep --text '^P:apk-tools-static$' -A1 | tail -n1 | cut -d: -f2
}

getapk() {
	curl -sSL $MAINREPO/$ARCH/apk-tools-static-"$(apkv)".apk |
		tar -xz -C $TMP sbin/apk.static
}

mkbase() {
	$TMP/sbin/apk.static --repository $MAINREPO --update-cache --allow-untrusted \
		--root $ROOTFS --initdb add alpine-base
}

conf() {
	printf '%s\n' $MAINREPO > $ROOTFS/etc/apk/repositories
	printf '%s\n' $ADDITIONALREPO >> $ROOTFS/etc/apk/repositories
}

pack() {
	local id
	id=$(tar --numeric-owner -C $ROOTFS -c . | docker import - alpine:$RELTAG)

	docker tag $id alpine:latest
	docker run -i -t --rm alpine printf 'alpine:%s with id=%s created!\n' $RELTAG $id
}

save() {
	[ $SAVE -eq 1 ] || return

	tar --numeric-owner -C $ROOTFS -c . | xz > rootfs.tar.xz
}

while getopts "hr:m:s" opt; do
	case $opt in
		r)
			REL=$OPTARG
			;;
		m)
			MIRROR=$OPTARG
			;;
		s)
			SAVE=1
			;;
		c)
			ADDITIONALREPO=community
			;;
		*)
			usage
			;;
	esac
done

# unless specified, build 'edge' Docker image
REL=${REL:-edge}
# in case of Docker image tag, we want to remove 'v' character out $REL to
# keep consistency with official (x86) Docker images of Alpine Linux
# e.g. build alpine:3.6 image instead of alpine:v3.6 as because the directory
# structure on alpinelinux.org does have the version dirs with 'v' prefix
RELTAG=$(echo $REL | sed 's|^v||')
MIRROR=${MIRROR:-https://nl.alpinelinux.org/alpine}
SAVE=${SAVE:-0}
MAINREPO=$MIRROR/$REL/main
ADDITIONALREPO=$MIRROR/$REL/community
ARCH=${ARCH:-$(uname -m)}

tmp
getapk
mkbase
conf
pack
save
