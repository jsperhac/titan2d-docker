# install Titan2d, with GUI, OpenMP, and its major dependencies
# build:
#   docker image build -t titan-gui .
# run:
#   docker run -it titan-gui /bin/sh
# test: refer to test directory...

# errors as follows from titan2d compilation:
# Cloning into 'titan2d'...
# configure.ac:59: installing './config.guess'
# configure.ac:59: installing './config.sub'
# configure.ac:5: installing './install-sh'
# configure.ac:5: installing './missing'
# /usr/share/automake-1.13/am/java.am: warning: JAVAROOT was already defined in condition ENABLE_JAVA_GUI, which is included in condition TRUE ...
# gui/Makefile.am:16:   while processing 'dist_noinst_JAVA'
# gui/Makefile.am:14: ... 'JAVAROOT' previously defined here
# src/adapt/Makefile.am: installing './depcomp'
# configure: WARNING: you should use --build, --host, --target
# configure: error: unrecognized option: `-j'
# Try `../../titan2d/configure --help' for more information
# The command '/bin/sh -c git clone https://github.com/TITAN2D/titan2d.git &&     cd titan2d &&     aclocal && autoheader && autoconf && automake --add-missing --copy &&     cd $TITAN_WSP/titan2d_bld/iccoptompmpi &&     ../../titan2d/configure --prefix=`pwd`         CXX=g++         CXXFLAGS=-O3         --enable-openmp         PYTHON=$TITAN_PYTHON/bin/python2.7         --with-gdal=$TITAN_GDAL         --with-hdf5=$TITAN_HDF5         --with-swig=$TITAN_SWIG     make -j $NUM_PROCESSES &&     make install' returned a non-zero code: 1


# so can we start at titan-deps??
FROM titan-deps:latest
LABEL desc="Titan2d install, try GUI, OpenMP, using titan-deps, centos:7"

ENV TITAN_WSP=/opt/titan_wsp

# core count for compilation
ENV NUM_PROCESSES=4

# system packages for GUI support

# Note: 
# Per https://github.com/numpy/numpy/releases,
# numpy.ndarray.tobytes has existed since version 1.9.
# PIL/Image.py is returning an error numpy.ndarray object has no attribute 'tobytes'.
# Per https://centos.pkgs.org/7/,
# yum install numpy will install numpy-1.7.1-13.el7.x86_64.
# Installing numpy version 1.11.0 per INSTALL.PORTABLE

# RUN yum -y install \
#            Cython \
#            gnuplot \
#            java-1.7.0-openjdk-devel \
#            numpy \
#            python-pillow

RUN yum -y install \
            Cython \
            gnuplot \
            java-1.7.0-openjdk-devel \
            python-pillow

# ====================================================================
# numpy installation
# ====================================================================
WORKDIR $TITAN_WSP/bld
RUN wget https://github.com/numpy/numpy/archive/v1.11.0.tar.gz && \
    tar xvzf v1.11.0.tar.gz && \
    cd numpy-1.11.0 && \
    python setup.py build && \
    python setup.py install

# ====================================================================
# images2gif installation
# note that this may put the lie to all our attempts to install
# system packages that work with our python version...
# ====================================================================
WORKDIR $TITAN_WSP/bld
RUN wget https://pypi.python.org/packages/d3/f9/4bd6d3dcf525cdbc7c0a4a15ab675edff81b6659dbd992abb5f5440c5c88/images2gif-1.0.1.tar.gz && \
    tar xvzf images2gif-1.0.1.tar.gz && \
    cd images2gif-1.0.1 && \
    python setup.py build && \
    python setup.py install

# instead let's use the devel package from the distro (provides javac, java, jar)
# java 1.7.0 openjdk
# ====================================================================
# java openjdk installation
# ====================================================================
# this may not be necessary as its in the distro:
#ADD --chown=root:root openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz /opt/titan_wsp/bld/


# ====================================================================
# titan2d configure, compile, and install
# including:
#   generate all autotools scripts (i.e. configure script and others).
# ====================================================================
#ENV TITAN_SWIG=`rpm -ql swig3 | grep bin | grep "/swig3"$ | awk -F 'swig3' '{print $1}'`

ENV TITAN_SWIG=/usr/bin
WORKDIR $TITAN_WSP/titan2d_bld/iccoptompmpi
WORKDIR $TITAN_WSP

RUN git clone https://github.com/TITAN2D/titan2d.git && \
    cd titan2d && \
    aclocal && autoheader && autoconf && automake --add-missing --copy && \
    cd $TITAN_WSP/titan2d_bld/iccoptompmpi && \
    ../../titan2d/configure --prefix=`pwd` \
        CXX=g++ \
        CXXFLAGS=-O3 \
        --enable-openmp \
        --with-gdal=$TITAN_GDAL \
        --with-hdf5=$TITAN_HDF5 \
        --with-swig=$TITAN_SWIG && \
    make -j $NUM_PROCESSES && \
    make install

