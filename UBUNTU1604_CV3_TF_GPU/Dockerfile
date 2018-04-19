FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
#Version v1.0
ENV CUDA_ARCH "30 35 52 61"

MAINTAINER CHIN SUN <nhoj62003@gmail.com>

# Set NVIDIA CONFIG
ENV CUDA_HOME /usr/local/cuda
ENV PATH ${CUDA_HOME}/bin:/usr/local/sbin:/usr/sbin:/sbin:${PATH}
ENV LD_LIBRARY_PATH ${CUDA_HOME}/lib:${CUDA_HOME}/lib64:/usr/lib:/usr/local/lib:${LD_LIBRARY_PATH}

# Set libcuda.so
RUN rm -rf /usr/lib/x86_64-linux-gnu/libcuda.so \
    && ln -s /usr/local/nvidia/lib64/libcuda.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so

# Install Enseentials 
RUN apt-get update \
    && apt-get install -y software-properties-common \
        python-software-properties \
        wget \
        vim \
        htop \
        git \
        curl \
        unzip \
        exuberant-ctags \
        ca-certificates \
        openssh-server \
        cmake

# Install OpenCV dependency lib
RUN apt-get update \
    && apt-get install -y python-pip \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && rm get-pip.py \
    && apt-get install -y python-dev \
        python-numpy \
        python-scipy \
        build-essential \
        cmake \
        pkg-config \
        libatlas-base-dev \
        gfortran \
        libjasper-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libv4l-dev \
        v4l-utils \
        python-opencv \
        python-skimage \
        libjpeg8-dev \
        libtiff5-dev \
        libxvidcore-dev \
        libx264-dev \
        libgtk-3-dev  \
    && apt-get update && apt-get install -y --no-install-recommends \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libprotobuf-dev \
        pkg-config \
        protobuf-compiler \
        python-yaml \
        python-matplotlib

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip 
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py
RUN pip --no-cache-dir install \
        Pillow \
        h5py \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        pandas \
        scipy \
        sklearn \
        && \
    python -m ipykernel.kernelspec

# Install OpenCV 3.2.0 with CUDA support
#ENV OPENCV_VER "2.4.13.4"
ENV OPENCV_VER "3.4.1"
RUN wget https://github.com/opencv/opencv/archive/"${OPENCV_VER}".tar.gz \
    && tar xzf "${OPENCV_VER}".tar.gz \
    && cd opencv-"${OPENCV_VER}" \
    && mkdir build \
    && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
       -DCMAKE_INSTALL_PREFIX=/usr/local \
       -DWITH_CUDA=ON -DCUDA_ARCH_BIN="${CUDA_ARCH}" -DCUDA_ARCH_PTX="${CUDA_ARCH}" \
       -DWITH_JPEG=ON -DBUILD_JPEG=ON -DWITH_PNG=ON -DBUILD_PNG=ON \
       -DENABLE_FAST_MATH=ON -DCUDA_FAST_MATH=ON \
       -DWITH_CUBLAS=ON \
       -DBUILD_SHARED_LIBS=ON \
       -DBUILD_NEW_PYTHON_SUPPORT=ON \
       -DPYTHON_EXECUTABLE=/usr/bin/python \
       -DWITH_GTK=ON .. \
    && make -j"$(nproc)" && make install && cd ../.. && rm -r opencv-"${OPENCV_VER}" && rm "${OPENCV_VER}".tar.gz

# Install TF dependency
## Bazel
RUN apt-get install -y openjdk-8-jdk \
    && echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
    && curl https://bazel.build/bazel-release.pub.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -y bazel \
    && apt-get upgrade -y bazel
## Python2.7 packages
#RUN apt-get install -y python-numpy \
#    python-dev \
#    python-pip \
#    python-wheel

## Python3 packages
RUN apt-get install -y python3-numpy \
        python3-dev \
        python3-pip \
        python3-wheel
#  upgrade h5py
RUN pip install h5py==2.8.0rc1

# NVIDIA requirements to run TensorFlow with GPU support
RUN apt-get install cuda-command-line-tools-8-0 \
    && export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64

# Clone TensorFlow repository and checkout version
ENV TENSORFLOW_VER "1.6.0"
#RUN git clone https://github.com/tensorflow/tensorflow \
#    && cd tensorflow \ 
#    && git checkout "${TENSORFLOW_VER}"
#RUN pip --no-cache-dir install \
#    http://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-"${TENSORFLOW_VER}"-cp27-none-linux_x86_64.whl
RUN pip --no-cache-dir install \
    http://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-"${TENSORFLOW_VER}"-cp27-none-linux_x86_64.whl



# install desktop environment
#RUN sudo add-apt-repository -y ppa:lubuntu-dev/lubuntu-daily && \
RUN apt-get install --reinstall ca-certificates && \ 
    add-apt-repository ppa:ubuntu-mate-dev/xenial-mate && \
    apt-get update && apt-get upgrade -y && \
    apt-get install mate -y && \
    apt-get dist-upgrade
#    sudo apt-get install lxqt-metapackage lxqt-panel openbox -y

# install lsusb
RUN apt-get install usbutils

RUN rm -rf /var/lib/apt/lists/*

# Set SSH Config
RUN mkdir -p /var/run/sshd

EXPOSE 22

# Start sshd
CMD /usr/sbin/sshd && /bin/bash
