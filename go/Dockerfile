# version = 0.0.1
FROM centos:latest
MAINTAINER Jordan Foo <foo.jordan@gmail.com>

# ###################
#
# Default Go Build Slave
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

# Setup Go environment
ENV GOVERSION=1.10
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/go
RUN mkdir /go
RUN mkdir /go/src
RUN mkdir /go/bin
WORKDIR /go/src

# Add this symlink so that jobs can use this intead of ssi-rcluster-buildslave without changing their DSL.
RUN ln -s /go /home/builder/go

# Symlink go executable so that we don’t need to mess with PATH at build time.
RUN ln -s /usr/local/go/bin/go /usr/local/bin/go

# Install Go
RUN wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz
RUN tar -C /usr/local/ -xzf go${GOVERSION}.linux-amd64.tar.gz
RUN rm go${GOVERSION}.linux-amd64.tar.gz

# Install github-release
# Lock down to v0.6.2, because it start breaking from v0.6.3 onwards.
RUN wget https://github.com/aktau/github-release/releases/download/v0.6.2/linux-amd64-github-release.tar.bz2
RUN tar -vxf linux-amd64-github-release.tar.bz2
RUN cp bin/linux/amd64/github-release /bin/
RUN rm linux-amd64-github-release.tar.bz2

# Setup builder as sudo user
RUN echo "builder    ALL=(ALL)    NOPASSWD: /usr/local/" >> /etc/sudoers && \
     echo "builder    ALL=(ALL)    NOPASSWD: /go/" >> /etc/sudoers
RUN chown -R builder /go
RUN chgrp -R builder /go
RUN chmod 777 /go