FROM ubuntu:16.04

# This Dockerfile just for FACE_RECOGNITION_SERVISE devoloper want to preprocessing images from dataset. 
# Therefore this Dockerfile will not include Caffe, Celery, and MongoDB. 
# The Dockerfile will include SSH, X2GO, OPENCV, DLIB.
# 
MAINTAINER CHIN SUN <nhoj62003@gmail.com>

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Configer package version
ENV DLIB_VER 19.2

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
RUN apt-get install -fqy software-properties-common python-software-properties openssh-server
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
RUN apt-get install -y libopenblas-base libopenblas-dev


# Install Python Module
RUN pip install --upgrade pip
RUN pip install numpy matplotlib
RUN pip install scipy scikit-learn
RUN pip install image

RUN apt-get install -y python-skimage


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


# Upgrade cmake to version 3.x
USER root
RUN add-apt-repository ppa:george-edison55/cmake-3.x -y
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y cmake

# Change USER
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

# Download Dlib
RUN wget http://dlib.net/files/dlib-$DLIB_VER.tar.bz2 -O dlib-$DLIB_VER.tar.bz2 && \
    tar jxvf dlib-$DLIB_VER.tar.bz2


# Compiling dlib CPLUSPLUS examples programs
WORKDIR /home/facerecognition/dlib-$DLIB_VER/examples
RUN mkdir build
WORKDIR /home/facerecognition/dlib-$DLIB_VER/examples/build
RUN cmake .. -DUSE_AVX_INSTRUCTIONS=1
RUN cmake --build .

# Compiling dlib Python API
USER root
WORKDIR /home/facerecognition/dlib-$DLIB_VER
RUN apt-get install -y libboost-all-dev
RUN python setup.py install --yes USE_AVX_INSTRUCTIONS

# Running dlib unit test suite
USER facerecognition
WORKDIR /home/facerecognition/dlib-$DLIB_VER/dlib/test
RUN mkdir build
WORKDIR /home/facerecognition/dlib-$DLIB_VER/dlib/test/build
RUN cmake .. -DUSE_AVX_INSTRUCTIONS=1
RUN cmake --build . --config Release
RUN ./dtest --runall

#Change USER to root
USER root
WORKDIR /home/facerecognition

# Remove no-use data
RUN rm -rf /var/lib/apt/lists/*

# Set User Passwordf
RUN echo "facerecognition:foxconn" | chpasswd

# Set SSH Config
RUN mkdir -p /var/run/sshd

EXPOSE 22

# Start sshd
CMD /usr/sbin/sshd && /bin/bash
