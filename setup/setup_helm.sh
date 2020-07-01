#! /bin/sh

apk add curl git

VERSION=2.16.9
CHECKSUM=197b9338129000f5d085b37e93ae3bcdd785901356a426dfa1f948d6b7a5a744
ARCH=amd64
FILENAME=helm-v$VERSION-linux-$ARCH.tar.gz

curl -O "https://get.helm.sh/$FILENAME"

if ! (echo "$CHECKSUM  $FILENAME" | sha256sum -c); then
	echo "$CHECKSUM  $FILENAME"
	sha256sum $FILENAME
	echo "Invalid checksum"
	exit 1;
fi

mkdir helm
mv "$FILENAME" helm/
cd helm
tar xvf "$FILENAME"
cp linux-$ARCH/helm /usr/bin/
cp linux-$ARCH/tiller /usr/bin/
cd ..
rm -rf helm
helm init --client-only
