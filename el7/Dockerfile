FROM centos:7
LABEL AUTHOR "Ben Nied <spacewreckage@gmail.com>"

RUN yum -y install gcc make bison flex git yum-utils spectool rpmbuild yum-builddep centos-release-scl wget
RUN yum clean all
RUN git clone https://github.com/bnied/kernel-ml-aufs.git /opt/kernel-ml-aufs
RUN wget https://sourceforge.net/projects/lxpup/files/Other/huge-kernels/kernel-5.10-aufs-changes/aufs-5.10-changed-files.tar.xz/download -O /opt/aufs-5.10-changed-files.tar.xz
RUN tar xvpf /opt/aufs-5.10-changed-files.tar.xz -C /opt/
RUN rm -rf /opt/aufs-5.10-changed-files.tar.xz

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
