FROM centos:8
LABEL AUTHOR "Ben Nied <spacewreckage@gmail.com>"

RUN dnf -y install gcc make bison flex git dnf-utils spectool rpm-build dnf-plugins-core wget
RUN dnf -y clean all
RUN git clone https://github.com/bnied/kernel-ml-aufs.git /opt/kernel-ml-aufs
RUN wget https://sourceforge.net/projects/lxpup/files/Other/huge-kernels/kernel-5.10-aufs-changes/aufs-5.10-changed-files.tar.xz/download -O /opt/aufs-5.10-changed-files.tar.xz
RUN tar xvpf /opt/aufs-5.10-changed-files.tar.xz -C /opt/
RUN rm -rf /opt/aufs-5.10-changed-files.tar.xz

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
