#!/usr/bin/env bash

# Set our base kernel version from the full version
IFS='.' read -r -a VERSION_ARRAY <<< $KERNEL_FULL_VERSION
KERNEL_BASE_VERSION="${VERSION_ARRAY[0]}.${VERSION_ARRAY[1]}"

# Make sure we have the latest code
cd /opt/kernel-ml-aufs
git pull

cd /opt/kernel-ml-aufs/specs-el6/

yum-builddep -y kernel-ml-aufs-$KERNEL_BASE_VERSION.spec

cd /opt/kernel-ml-aufs/
mkdir -p /root/rpmbuild/SOURCES
mkdir /root/rpmbuild/SPECS
mkdir /root/rpmbuild/RPMS
mkdir /root/rpmbuild/SRPMS

cp configs-el6/config-$KERNEL_FULL_VERSION* /root/rpmbuild/SOURCES/
cp specs-el6/kernel-ml-aufs-$KERNEL_BASE_VERSION.spec /root/rpmbuild/SPECS/

cd /root/rpmbuild/SOURCES/
git clone git://github.com/sfjro/aufs5-standalone.git -b aufs$KERNEL_BASE_VERSION aufs-standalone

cd /root/rpmbuild/SOURCES/aufs-standalone
export HEAD_COMMIT=$(git rev-parse --short HEAD); git archive $HEAD_COMMIT > ../aufs-standalone.tar

cd /root/rpmbuild/SOURCES/
rm -rf aufs-standalone

cd /root/rpmbuild/SPECS/
spectool -g -C /root/rpmbuild/SOURCES/ kernel-ml-aufs-$KERNEL_BASE_VERSION.spec
rpmbuild -bs kernel-ml-aufs-$KERNEL_BASE_VERSION.spec

cd /root/rpmbuild/SRPMS/
rpmbuild --rebuild kernel-ml-aufs-$KERNEL_FULL_VERSION-$RELEASE_VERSION.el6.src.rpm

mkdir -p /root/ml

mkdir -p /root/ml/SRPMS
cp -av /root/rpmbuild/SRPMS/* /root/ml/SRPMS/
cp -av /root/rpmbuild/RPMS/* /root/ml/
