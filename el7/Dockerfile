FROM centos:latest
LABEL AUTHOR "Ben Nied <spacewreckage@gmail.com>"
ENV KERNEL_FULL_VERSION 4.19.1
ENV KERNEL_BASE_VERSION 4.19
ENV RELEASE_VERSION 1

RUN yum -y install gcc make bison flex git yum-utils spectool rpmbuild yum-builddep
RUN git clone https://github.com/bnied/kernel-ml-aufs.git /opt/kernel-ml-aufs

WORKDIR /opt/kernel-ml-aufs/specs-el7/

RUN yum-builddep -y kernel-ml-aufs-$KERNEL_BASE_VERSION.spec

WORKDIR /opt/kernel-ml-aufs/
RUN mkdir -p /root/rpmbuild/SOURCES
RUN mkdir /root/rpmbuild/SPECS
RUN mkdir /root/rpmbuild/RPMS
RUN mkdir /root/rpmbuild/SRPMS

RUN cp configs-el7/config-$KERNEL_FULL_VERSION* /root/rpmbuild/SOURCES/
RUN cp configs-el7/cpupower.* /root/rpmbuild/SOURCES/
RUN cp specs-el7/kernel-ml-aufs-$KERNEL_BASE_VERSION.spec /root/rpmbuild/SPECS/

WORKDIR /root/rpmbuild/SOURCES/
RUN echo $KERNEL_BASE_VERSION
RUN git clone git://github.com/sfjro/aufs4-standalone.git -b aufs$KERNEL_BASE_VERSION aufs-standalone

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
RUN rpmbuild --rebuild kernel-ml-aufs-$KERNEL_FULL_VERSION-$RELEASE_VERSION.el7.src.rpm

RUN mkdir -p /root/ml
RUN rm -rf /root/ml/*

RUN cp -av /root/rpmbuild/SRPMS/*.rpm /root/ml/
RUN cp -av /root/rpmbuild/RPMS/*.rpm /root/ml/
