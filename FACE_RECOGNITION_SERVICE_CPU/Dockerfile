FROM ubuntu:16.04

# This Dockerfile just upgrade Ubuntu to 16.04 form JOE's FACE_RECOGNITION_SERVICE/CPU Dockerfile. 
# for detail as link:
# (github.com/joeking11829/Docker-Dev/tree/master/FACE_RECOGNITION_SERVICE/CPU)
MAINTAINER CHIN SUN <nhoj62003@gmail.com>

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Create USER
RUN useradd -d /home/facerecognition -m -s /bin/bash facerecognition
RUN adduser facerecognition sudo
RUN usermod -a -G video facerecognition

#USER facerecognition
WORKDIR /home/facerecognition

# Install apt-utils
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -fqy apt-utils && apt-get autoremove

# Install X2GO
RUN apt-get update
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -fqy software-properties-common python-software-properties openssh-server
RUN add-apt-repository ppa:x2go/stable -y && apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x2goserver x2goserver-xsession

RUN apt-get autoremove

# Install MATE Desktop
RUN apt-add-repository ppa:ubuntu-mate-dev/xenial-mate && apt-get -y install mate-core mate-desktop-environment
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mate-desktop-environment-core && apt-get install -y x2gomatebindings
RUN apt-get install -y wget vim htop git curl unzip

# Install OpenCV dependency lib
RUN apt-get install -y python-dev python-pip python-numpy build-essential cmake pkg-config libatlas-base-dev gfortran \
                            libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev \
                            libswscale-dev libjpeg-dev libpng-dev libtiff-dev libv4l-dev v4l-utils

# Install Celery dependency lib
RUN pip install --upgrade pip
RUN pip install Celery flower tornado tornado-celery
RUN pip install tornado --upgrade
RUN pip install pika==0.9.14 --force-reinstall
RUN apt-get install -y rabbitmq-server nodejs-legacy npm

#Install MongoDB and dependency lib
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
RUN apt-get update
RUN apt-get install -y mongodb-org libssl-dev libsasl2-dev
RUN pip install pymongo

# Install Python Module
RUN pip install numpy matplotlib

#Install caffe dependency lib
RUN apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
RUN apt-get install -y --no-install-recommends libboost-all-dev
RUN apt-get install -y libatlas-base-dev
RUN apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev
RUN apt-get install -y libopenblas-base libopenblas-dev

# Install Python Module
RUN pip install scipy scikit-learn

# Change User
USER facerecognition
WORKDIR /home/facerecognition

# Install OpenCV
# Download PrimeSense Binary
RUN mkdir xtion_pro
WORKDIR /home/facerecognition/xtion_pro
RUN wget https://github.com/joeking11829/CameraPSB/blob/master/Bin/OpenNI-Bin-Dev-Linux-x64-v1.5.2.23.tar.bz2?raw=true -O OpenNI-Bin-Dev-Linux-x64-v1.5.2.23.tar.bz2
RUN wget https://github.com/joeking11829/CameraPSB/blob/master/Bin/Sensor-Bin-Linux-x64-v5.1.0.41.tar.bz2?raw=true -O Sensor-Bin-Linux-x64-v5.1.0.41.tar.bz2
RUN tar jxvf OpenNI-Bin-Dev-Linux-x64-v1.5.2.23.tar.bz2
RUN tar jxvf Sensor-Bin-Linux-x64-v5.1.0.41.tar.bz2

# Install PrimeSense Lib
USER root
RUN cd OpenNI-Bin-Dev-Linux-x64-v1.5.2.23 && ./install.sh
RUN cd Sensor-Bin-Linux-x64-v5.1.0.41 && ./install.sh
USER facerecognition
WORKDIR /home/facerecognition

# Download OpenCV
RUN wget https://github.com/Itseez/opencv/archive/3.0.0.zip -O opencv-3.0.0.zip && \
    unzip -q opencv-3.0.0.zip

# Build OpenCV
RUN mkdir opencv-3.0.0/release
WORKDIR /home/facerecognition/opencv-3.0.0/release
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_V4L=ON \
          -D WITH_IPP=OFF \
          -D WITH_OPENNI=ON \
          ..

RUN make -j"$(nproc)"

# Install OpenCV Lib
USER root
RUN make install
RUN ldconfig
RUN echo "usr/local/liib" >> /etc/ld.so.conf.d/opencv.conf && ldconfig -v
RUN export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH && ldconfig
RUN export LD_LIBRARY_PATH=/home/facerecognition/opencv-3.0.0/release/:$LD_LIBRARY_PATH && ldconfig
RUN echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" >> /etc/bash.bashrc
# Install OpenCV-Python2.7 cv2.so
RUN cp lib/cv2.so /usr/lib/python2.7/dist-packages/.

# Change USER
USER facerecognition
WORKDIR /home/facerecognition

# Download Caffe repository
RUN git clone https://github.com/BVLC/caffe.git
WORKDIR /home/facerecognition/caffe

#Install Caffe python requirement
USER root
#RUN pip install cython
#RUN pip install -r python/requirements.txt
RUN for req in $(cat python/requirements.txt) pydot; do pip install $req; done

#Set Caffe build config
USER facerecognition
RUN cp Makefile.config.example Makefile.config
RUN sed -i "s/# CPU_ONLY := 1/CPU_ONLY := 1/g" Makefile.config
RUN sed -i "s/BLAS := atlas/BLAS := open/g" Makefile.config
RUN sed -i "s/# OPENCV_VERSION := 3/OPENCV_VERSION := 3/g" Makefile.config
RUN sed -i "s/# WITH_PYTHON_LAYER := 1/WITH_PYTHON_LAYER := 1/g" Makefile.config


# Relink and Reload - libhdf5.so and libhdf5_hl.so
# The lib names of hdf5 on debian have a postfix "serial"
# , therefore -lhdf5 and -lhdf5_hl cannot be found.
USER root
RUN ln -s /usr/lib/x86_64-linux-gnu/libhdf5_serial.so.10.1.0 /usr/local/lib/libhdf5.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libhdf5_serial_hl.so.10.0.2 /usr/local/lib/libhdf5_hl.so
RUN ldconfig

USER facerecognition

# transformations :
#  #include "hdf5/serial/hdf5.h" -> #include "hdf5/serial/hdf5.h"
#  #include "hdf5_hl.h" -> #include "hdf5/serial/hdf5_hl.h"
RUN find . -type f -exec sed -i -e 's^"hdf5.h"^"hdf5/serial/hdf5.h"^g' -e 's^"hdf5_hl.h"^"hdf5/serial/hdf5_hl.h"^g' '{}' \;


#Build Caffe
RUN make all -j"$(nproc)"
#RUN make test -j"$(nproc)"
#RUN make runtest -j"$(nproc)"

#Build Caffe python interface
RUN make pycaffe -j"$(nproc)"

# Change WORKDIR
WORKDIR /home/facerecognition

# Download Dlib
RUN wget http://dlib.net/files/dlib-19.0.tar.bz2 -O dlib-19.0.tar.bz2 && \
    tar jxvf dlib-19.0.tar.bz2

#Install adminMongoDB
RUN mkdir adminMongo
WORKDIR /home/facerecognition/adminMongo
RUN npm install admin-mongo

#Install MongoDB CXX Driver
WORKDIR /home/facerecognition
#a. install libbson
RUN wget https://github.com/mongodb/libbson/releases/download/1.4.0/libbson-1.4.0.tar.gz
RUN tar -xzf libbson-1.4.0.tar.gz
WORKDIR /home/facerecognition/libbson-1.4.0
RUN ./configure --prefix=/usr --libdir=/usr/lib
RUN make -j"$(nproc)"

#Install libbson lib to system
USER root
RUN make install
USER facerecognition

#b. install libmongoc (MongoDB C Driver)
WORKDIR /home/facerecognition
RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.4.2/mongo-c-driver-1.4.2.tar.gz
RUN tar xzf mongo-c-driver-1.4.2.tar.gz
WORKDIR /home/facerecognition/mongo-c-driver-1.4.2
RUN ./configure
RUN make -j"$(nproc)"

#Install libmongoc to system
USER root
RUN make install

#c. upgrade cmake to version 3.2
RUN add-apt-repository ppa:george-edison55/cmake-3.x -y
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y cmake

#d. install mongodb-cxx-driver
USER facerecognition
WORKDIR /home/facerecognition
RUN curl -OL https://github.com/mongodb/mongo-cxx-driver/archive/r3.0.1.tar.gz
RUN tar -xzf r3.0.1.tar.gz
WORKDIR /home/facerecognition/mongo-cxx-driver-r3.0.1/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..

#Install mongodb-cxx-driver to system
USER root
RUN make -j"$(nproc)" && make install

#Relink and Reload - libmongocxx.so._noabi and libbsoncxx.so._noabi
RUN rm /usr/local/lib/lib*.so._noabi
RUN ln -s /usr/local/lib/libmongocxx.so.3.0.1 /usr/local/lib/libmongocxx.so._noabi
RUN ln -s /usr/local/lib/libbsoncxx.so.3.0.1 /usr/local/lib/libbsoncxx.so._noabi
RUN ldconfig

#Change WORKDIR to /home/facerecognition
WORKDIR /home/facerecognition

#create VOLUME "/data/db" for MongoDB
VOLUME /data/db
RUN chown -R facerecognition /data/db
RUN locale-gen en_US.UTF-8

#Change USER to root
USER root

# Remove no-use data
RUN rm -rf /var/lib/apt/lists/*

# Set User Passwordf
RUN echo "facerecognition:foxconn" | chpasswd

# Set SSH Config
RUN mkdir -p /var/run/sshd

EXPOSE 22

# Start sshd
CMD /usr/sbin/sshd && /usr/bin/mongod --fork --logpath /var/log/mongodb/mongodb.log --logappend && rabbitmq-server -detached  && /bin/bash
