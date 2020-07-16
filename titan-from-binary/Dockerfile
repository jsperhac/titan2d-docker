# most basic install, from the tarball
#
# build image from this Dockerfile (using example tag, omit 0.1 for "latest"):
#	docker build --tag titan-from-binary:0.1 .
# create container from the resulting image:
#	docker run -it titan-from-binary:0.1 /bin/sh

FROM centos:7
LABEL desc="Titan2d test install from binaries, v4.0.0"
ENV TITAN_WSP=/opt/titan_wsp
WORKDIR $TITAN_WSP

# something is presently going wrong here
RUN yum -y install wget

RUN wget https://github.com/TITAN2D/titan2d/releases/download/v4.0.0/titan2d-v4.0.0-Linux-64bit.tar.gz && \
	tar xvzf titan2d-v4.0.0-Linux-64bit.tar.gz

#To test:
#
# in example directory:
#	cd titan2d-v4.0.0/share/titan2d_examples/colimafinemini/Coulomb
#
#execute with 2 threads:
#	../../../../bin/titan -nt 2 input.py
