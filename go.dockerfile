# To build/tag/push: docker build -t "chomey/go-build-slave" -f "go.dockerfile" . && docker push "chomey/go-build-slave"
FROM chomey/centos
MAINTAINER Jordan Foo <foo.jordan@gmail.com>

# ###################
#
# Default Go Build Slave
#
# ###################

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

# Setup builder as sudo user
RUN echo "builder    ALL=(ALL)    NOPASSWD: /go/" >> /etc/sudoers
RUN chown -R builder /go
RUN chgrp -R builder /go
RUN chmod 777 /go