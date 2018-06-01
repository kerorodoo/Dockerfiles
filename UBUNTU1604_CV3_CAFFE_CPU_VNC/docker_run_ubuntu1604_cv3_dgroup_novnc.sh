#!/bin/bash
docker stop ubuntu1604-cv3-caffe-cpu
docker rm ubuntu1604-cv3-caffe-cpu
docker run -d -p 5901:5901 -p 6901:6901 \
        -p 2201:22 -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys \
        --name=ubuntu1604-cv3-caffe-cpu \
        -v ~/.vim:/root/.vim -v ~/.vimrc:/root/.vimrc \
        -v ~/.vim:/headless/.vim -v ~/.vimrc:/headless/.vimrc \
    -v $(pwd)/WH:/root/WH \
    -v $(pwd)/WH/Files:/root/shared \
    -v $(pwd)/googletest:/root/WH/googletest \
    -v $(pwd)/ttyUSB0:/dev/ttyUSB0 \
        -v $(pwd)/wallpaper.jpg:/headless/.config/bg_sakuli.png \
        -v $(pwd)/caffe:/root/caffe \
        --user 0 -e VNC_PW=0000 -e VNC_RESOLUTION=1400x1050 \
        ubuntu1604-cv3-caffe-cpu
