FROM ubuntu
MAINTAINER docker@deliverous.com

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y curl build-essential git bzr mercurial && apt-get clean

# Install Go
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /usr/local/go/
RUN hg clone -u release https://code.google.com/p/go /usr/local/go
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
RUN go get code.google.com/p/go.tools/cmd/...
RUN go install code.google.com/p/go.tools/cmd/...

# Perpare build workspace
ENV GOROOT /usr/local/go/
ENV GOPATH /workspace
RUN mkdir /workspace
ADD build /usr/local/bin/build
RUN chmod 755 /usr/local/bin/build

# Prepare ssh share space
RUN mkdir /ssh

VOLUME ["/workspace", "/output", "/ssh"]
ENTRYPOINT ["/usr/local/bin/build"]
