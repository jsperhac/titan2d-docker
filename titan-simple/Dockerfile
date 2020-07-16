# install Titan2d, no GUI, system Python2, OpenMP, and its major dependencies
#
# build:
#   docker build --tag titan-simple .
# run:
#   docker run -it titan-simple /bin/sh
# test example:
#       cd /opt/titan_wsp/titan2d_bld/iccoptompmpi/share/titan2d_examples/colimafinemini/Coulomb
#   execute with 2 threads:
#	    ../../../../bin/titan -nt 2 input.py
#
FROM centos:7
LABEL desc="Titan2d install, no GUI, system Python2, OpenMP, with dependencies, centos:7"

# Create directories for the build
ENV TITAN_WSP=/opt/titan_wsp

# core count for compilation
ENV NUM_PROCESSES=4

# system packages
RUN yum -y update && \
    yum -y install \
        autoconf \
        automake \
        gcc-c++ \
        git \
        make \
        python-devel \
        swig3 \
        wget \
        zlib*

# ====================================================================
# hdf5 installation
#   hierarchical data format (HDF)
# ====================================================================
# serial version of hdf5 with C++ support

ENV HDF5_VERSION=1.8.18
ENV TITAN_HDF5=${TITAN_WSP}/hdf5-${HDF5_VERSION}
WORKDIR $TITAN_WSP/bld

RUN wget -q https://support.hdfgroup.org/ftp/HDF5/prev-releases/hdf5-1.8/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar && \
    tar xvf hdf5-${HDF5_VERSION}.tar && \
    cd hdf5-${HDF5_VERSION} && \
    ./configure --prefix=$TITAN_HDF5 --enable-cxx && \
    make -j $NUM_PROCESSES && \
    make install

# ====================================================================
# GDAL installation
#   translator library for raster and vector geospatial data
# ====================================================================

ENV GDAL_VERSION=2.1.0
ENV TITAN_GDAL=${TITAN_WSP}/gdal-${GDAL_VERSION}
WORKDIR $TITAN_WSP/bld

RUN wget -q http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz && \
    tar xvzf gdal-${GDAL_VERSION}.tar.gz && \
    cd gdal-${GDAL_VERSION} && \
    ./configure --prefix=$TITAN_GDAL \
        --with-png=internal \
        --with-jpeg=internal \
        --without-curl \
        --without-pg \
        --without-mysql \
        --without-sqlite3 \
        --without-pcre \
        --without-xml2 && \
    make -j $NUM_PROCESSES && \
    make install

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
        --with-swig=$TITAN_SWIG \
        --disable-java-gui && \
    make -j $NUM_PROCESSES && \
    make install

