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
        vim \
        htop \
        unzip \
        ca-certificates \
        openssh-server \
        cmake \
        git \
        wget \
        curl \
        exuberant-ctags

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
        ca-certificates \
        openssh-server \
        cmake \
        git \
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
RUN add-apt-repository ppa:deadsnakes/ppa \
        && apt-get update \
        && apt-get install python \
          python-dev \
          python-pip \
        && apt-get install -y python3.6 \
          python3-pip \
          python3.6-dev \
          python3-wheel \
        && pip3 install numpy \
          scikit-image \
          Pillow \
          h5py \
          ipykernel \
          jupyter \
          matplotlib \
          pandas \
          scipy \
          sklearn \
          matplotlib


#  upgrade h5py
RUN python3.6 -m pip install h5py==2.8.0rc1

# NVIDIA requirements to run TensorFlow with GPU support
RUN apt-get install cuda-command-line-tools-8-0 \
    && export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64

# Clone TensorFlow repository and checkout version
ENV TENSORFLOW_VER "1.4.0"
ENV PYTHON_VER "36"
#RUN git clone https://github.com/tensorflow/tensorflow \
#    && cd tensorflow \ 
#    && git checkout "${TENSORFLOW_VER}"
#RUN python3.6 -m pip install --upgrade pip \ 
#    && wget -c https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-"${TENSORFLOW_VER}"-cp"${PYTHON_VER}"-cp"${PYTHON_VER}"m-linux_x86_64.whl \
#    && python3.6 -m pip --no-cache-dir install tensorflow-"${TENSORFLOW_VER}"-cp"${PYTHON_VER}"-cp"${PYTHON_VER}"m-linux_x86_64.whl
RUN python3.6 -m pip install --upgrade pip \
    && wget -c https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-"${TENSORFLOW_VER}"-cp"${PYTHON_VER}"-cp"${PYTHON_VER}"m-linux_x86_64.whl \
    && python3.6 -m pip --no-cache-dir install tensorflow_gpu-"${TENSORFLOW_VER}"-cp"${PYTHON_VER}"-cp"${PYTHON_VER}"m-linux_x86_64.whl


# install desktop environment
#RUN sudo add-apt-repository -y ppa:lubuntu-dev/lubuntu-daily && \
RUN apt-get install --reinstall ca-certificates && \ 
    add-apt-repository ppa:ubuntu-mate-dev/xenial-mate && \
    apt-get update && apt-get upgrade -y && \
    apt-get install mate -y && \
    apt-get dist-upgrade
#    sudo apt-get install lxqt-metapackage lxqt-panel openbox -y
#RUN pip install tensorflow==1.6.0

# install lsusb
RUN apt-get install usbutils

RUN rm -rf /var/lib/apt/lists/*

# link GLX driver
RUN ln -s /usr/local/nvidia/lib64/libGLX_indirect.so.0 /usr/lib/libGLX_indirect.so.0

# create symbolic link and alias
RUN rm /usr/bin/python3 &&\
    ln -s /usr/bin/python3.6 /usr/bin/python3 &&\
    alias python3='/usr/bin/python3.6'

# Set SSH Config
RUN mkdir -p /var/run/sshd

EXPOSE 22

# Start sshd
CMD /usr/sbin/sshd && /bin/bash
