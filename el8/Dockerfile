FROM oraclelinux:8-slim
LABEL AUTHOR "Ben Nied <spacewreckage@gmail.com>"
ENV KERNEL_FULL_VERSION 5.2.7
ENV KERNEL_BASE_VERSION 5.2
ENV RELEASE_VERSION 1

RUN dnf -y install gcc make bison flex git dnf-utils spectool rpm-build dnf-plugins-core
RUN git clone https://github.com/bnied/kernel-ml-aufs.git /opt/kernel-ml-aufs

WORKDIR /opt/kernel-ml-aufs/specs-el8/
RUN export KERNEL_FULL_VERSION=`cat ../specs-el8/kernel-ml-aufs-$KERNEL_BASE_VERSION.spec | grep "%define LKAver" | awk '{print $3}'`
RUN dnf builddep -y kernel-ml-aufs-$KERNEL_BASE_VERSION.spec

WORKDIR /opt/kernel-ml-aufs/
RUN mkdir -p /root/rpmbuild/SOURCES
RUN mkdir /root/rpmbuild/SPECS
RUN mkdir /root/rpmbuild/RPMS
RUN mkdir /root/rpmbuild/SRPMS

RUN cp configs-el8/config-$KERNEL_FULL_VERSION* /root/rpmbuild/SOURCES/
RUN cp configs-el8/cpupower.* /root/rpmbuild/SOURCES/
RUN cp specs-el8/kernel-ml-aufs-$KERNEL_BASE_VERSION.spec /root/rpmbuild/SPECS/

WORKDIR /root/rpmbuild/SOURCES/
RUN echo $KERNEL_BASE_VERSION
RUN git clone git://github.com/sfjro/aufs5-standalone.git -b aufs$KERNEL_BASE_VERSION aufs-standalone

WORKDIR /root/rpmbuild/SOURCES/aufs-standalone
RUN echo ${HEAD_COMMIT}
RUN export HEAD_COMMIT=$(git rev-parse --short HEAD); git archive $HEAD_COMMIT > ../aufs-standalone.tar

WORKDIR /root/rpmbuild/SOURCES/
RUN rm -rf aufs-standalone

WORKDIR /root/rpmbuild/SPECS/
RUN printenv
RUN spectool -g -C /root/rpmbuild/SOURCES/ kernel-ml-aufs-$KERNEL_BASE_VERSION.spec
RUN rpmbuild -bs kernel-ml-aufs-$KERNEL_BASE_VERSION.spec

WORKDIR /root/rpmbuild/SRPMS/
RUN rpmbuild --rebuild *.el8.src.rpm

RUN mkdir -p /root/ml
RUN rm -rf /root/ml/*

RUN cp -av /root/rpmbuild/SRPMS/*.rpm /root/ml/
RUN cp -av /root/rpmbuild/RPMS/*.rpm /root/ml/
