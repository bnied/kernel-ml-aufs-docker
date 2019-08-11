FROM i386/centos:6
LABEL AUTHOR "Ben Nied <spacewreckage@gmail.com>"
ENV KERNEL_FULL_VERSION 5.2.7
ENV KERNEL_BASE_VERSION 5.2
ENV RELEASE_VERSION 1

RUN echo "i386" > /etc/yum/vars/basearch

ADD cfg/devtoolset-3.repo /etc/yum.repos.d/
RUN yum -y install gcc make bison flex git yum-utils spectool rpmbuild yum-builddep devtoolset-3-toolchain
RUN git clone https://github.com/bnied/kernel-ml-aufs.git /opt/kernel-ml-aufs

WORKDIR /opt/kernel-ml-aufs/specs-el6/

RUN yum-builddep -y kernel-ml-aufs-$KERNEL_BASE_VERSION.spec

WORKDIR /opt/kernel-ml-aufs/
RUN mkdir -p /root/rpmbuild/SOURCES
RUN mkdir /root/rpmbuild/SPECS
RUN mkdir /root/rpmbuild/RPMS
RUN mkdir /root/rpmbuild/SRPMS

RUN cp configs-el6/config-$KERNEL_FULL_VERSION* /root/rpmbuild/SOURCES/
RUN cp specs-el6/kernel-ml-aufs-$KERNEL_BASE_VERSION.spec /root/rpmbuild/SPECS/

WORKDIR /root/rpmbuild/SOURCES/
RUN echo $KERNEL_BASE_VERSION
RUN git clone git://github.com/sfjro/aufs5-standalone.git -b aufs$KERNEL_BASE_VERSION aufs-standalone

WORKDIR /root/rpmbuild/SOURCES/aufs-standalone
ENV HEAD_COMMIT $(git rev-parse --short HEAD)
RUN echo ${HEAD_COMMIT}
RUN export HEAD_COMMIT=$(git rev-parse --short HEAD); git archive $HEAD_COMMIT > ../aufs-standalone.tar

WORKDIR /root/rpmbuild/SOURCES/
RUN rm -rf aufs-standalone

WORKDIR /root/rpmbuild/SPECS/
RUN spectool -g -C /root/rpmbuild/SOURCES/ kernel-ml-aufs-$KERNEL_BASE_VERSION.spec
RUN rpmbuild -bs kernel-ml-aufs-$KERNEL_BASE_VERSION.spec

WORKDIR /root/rpmbuild/SRPMS/
RUN rpmbuild --rebuild kernel-ml-aufs-$KERNEL_FULL_VERSION-$RELEASE_VERSION.el6.src.rpm

RUN mkdir -p /root/ml
RUN rm -rf /root/ml/*

RUN cp -av /root/rpmbuild/SRPMS/*.rpm /root/ml/
RUN cp -av /root/rpmbuild/RPMS/*.rpm /root/ml/
