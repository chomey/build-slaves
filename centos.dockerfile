# To build/tag/push: docker build -t "chomey/centos-build-slave-base" -f "centos.dockerfile" . && docker push "chomey/centos-build-slave-base"
FROM centos:latest
MAINTAINER Jordan Foo <foo.jordan@gmail.com>

# ###################
#
# Default Centos Build Slave
#
# ###################

RUN yum update -y
RUN yum install wget -y
RUN yum install tar -y
RUN yum install bzip2 -y
RUN yum install make -y
RUN yum install git -y

# create user builder
RUN adduser builder
RUN usermod -aG wheel builder

# install docker and setup sudo
RUN wget https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 && \
   mv docker-1.10.3 /usr/bin/docker && chmod +x /usr/bin/docker && \
   echo "builder    ALL=(ALL)    NOPASSWD: /usr/bin/docker" >> /etc/sudoers

# Setup builder as sudo user
RUN echo "builder    ALL=(ALL)    NOPASSWD: /usr/local/" >> /etc/sudoers

# Install github-release
# Lock down to v0.6.2, because it start breaking from v0.6.3 onwards.
RUN wget https://github.com/aktau/github-release/releases/download/v0.6.2/linux-amd64-github-release.tar.bz2
RUN tar -vxf linux-amd64-github-release.tar.bz2
RUN cp bin/linux/amd64/github-release /bin/
RUN rm linux-amd64-github-release.tar.bz2

