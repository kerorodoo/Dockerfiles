FROM docker-face-recognition-dev-preprocessing-cpu

# This Dockerfile base on Dockerfile, in Parent folder (FACE_RECOGNITION_DEVELOPER_PREPROCESSING_CPU) 
# The Dockerfile contained the facealignment and the anti-spoof face for project.
# 
MAINTAINER CHIN SUN <nhoj62003@gmail.com>

USER root
WORKDIR /home/facerecognition

# update package
RUN apt-get update
RUN apt-get install -y libopenblas-dev liblapack-dev

USER facerecognition
WORKDIR /home/facerecognition

# clone the project (SWD_DLID) form git
RUN git clone -v --progress https://github.com/kerorodoo/assignment1.git SWD_DLIB
WORKDIR /home/facerecognition/SWD_DLIB/examples
RUN mkdir build
WORKDIR /home/facerecognition/SWD_DLIB/examples/build
RUN cmake .. -DUSE_AVX_INSTRUCTIONS=1
RUN cmake --build .

USER facerecognition
WORKDIR /home/facerecognition


# clone the project (SWD_ALIGNMENT) form git
RUN git clone -v --progress https://github.com/kerorodoo/alignment.git SWD_ALIGNMENT
WORKDIR /home/facerecognition/SWD_ALIGNMENT
RUN make clean
RUN make 

WORKDIR /home/facerecognition

