#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

BUILD_CONFIG=$1
if [ -z "$1" ] ; then
    BUILD_CONFIG=release
fi

BUILD_PLATFORM=$2
if [ -z "$2" ] ; then
    BUILD_PLATFORM=wasm
fi

# Download OpenCV source code
OPENCV_VERSION=4.5.1
OPENCV_PACKAGE=opencv-$OPENCV_VERSION
OPENCV_ZIP=$THIS_DIR/${OPENCV_PACKAGE}.zip
if [ ! -f $OPENCV_ZIP ]; then
    wget -O $OPENCV_ZIP https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
    unzip -qq $OPENCV_ZIP
fi

BUILD_DIR=$THIS_DIR/build_${BUILD_PLATFORM}_${BUILD_CONFIG}
INSTALL_DIR=$THIS_DIR/install_${BUILD_PLATFORM}_${BUILD_CONFIG}

if [ -d $INSTALL_DIR ]; then
   exit
fi


# Build OpenCV
if [ $BUILD_PLATFORM == "wasm" ]; then
    echo 'Running wasm build ... ${BUILD_DIR} '
    source /emsdk/emsdk_env.sh
    cmake -G Ninja -B${BUILD_DIR} \
       -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
       -DCMAKE_BUILD_TYPE=${BUILD_CONFIG} \
       -DCV_ENABLE_INTRINSICS=OFF \
       -DENABLE_PIC=FALSE \
       -DBUILD_IPP_IW=OFF \
       -DWITH_TBB=OFF \
       -DWITH_OPENMP=OFF \
       -DWITH_PTHREADS_PF=OFF \
       -DWITH_OPENCL=OFF \
       -DWITH_IPP=OFF \
       -DWITH_ITT=OFF \
       -DCPU_BASELINE='' \
       -DCPU_DISPATCH='' \
       -DSIZEOF_SIZE_T_run_result=0 \
       -DSIZEOF_SIZE_T_run_result__TRYRUN_OUTPUT=4 \
       -DSIZEOF_UNSIGNED_LONG_run_result=0 \
       -DSIZEOF_UNSIGNED_LONG_run_result__TRYRUN_OUTPUT=4 \
       -DBUILD_SHARED_LIBS=OFF \
       -DBUILD_DOCS=OFF \
       -DWITH_QUIRC=ON \
       -DWITH_PROTOBUF=ON \
       -DBUILD_PERF_TESTS=OFF \
       -DBUILD_ILMIMF=ON \
       -DBUILD_ZLIB=ON \
       -DBUILD_JASPER=ON \
       -DBUILD_PNG=ON \
       -DBUILD_JPEG=ON \
       -DBUILD_TIFF=OFF \
       -DBUILD_opencv_apps=OFF \
       -DBUILD_DOCS=OFF \
       -DBUILD_TESTS=OFF \
       -DWITH_JASPER=ON \
       -DWITH_PYTHON=OFF \
       -DWITH_PYTHON2=OFF \
       -DWITH_JAVA=OFF \
       -DWITH_FFMPEG=OFF \
       -DWITH_MSMF=OFF \
       -DWITH_VFW=OFF \
       -DWITH_OPENEXR=OFF \
       -DWITH_WEBP=OFF \
       -DWITH_TIFF=OFF \
       -DBUILD_opencv_java=OFF \
       -DBUILD_opencv_python=OFF \
       -DBUILD_opencv_python2=OFF \
       -DBUILD_opencv_python3=OFF \
       -DBUILD_opencv_python_bindings_generator=OFF \
       -DCMAKE_MODULE_PATH=$EMSDK/upstream/emscripten/cmake \
       -DCMAKE_TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake \
       -DBUILD_LIST=core,imgproc,imgcodecs,objdetect,dnn \
       $THIS_DIR/$OPENCV_PACKAGE
fi


if [ $BUILD_PLATFORM == "x64" ]; then
    echo 'Running x64 build ... '
    cmake -G Ninja -B${BUILD_DIR} \
       -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
       -DCMAKE_BUILD_TYPE=${BUILD_CONFIG} \
       -DBUILD_SHARED_LIBS=OFF \
       -DBUILD_DOCS=OFF \
       -DBUILD_QUIRC=ON \
       -DBUILD_PROTOBUF=ON \
       -DBUILD_PERF_TESTS=OFF \
       -DBUILD_ILMIMF=ON \
       -DBUILD_ZLIB=ON \
       -DBUILD_JASPER=ON \
       -DBUILD_PNG=ON \
       -DBUILD_JPEG=ON \
       -DBUILD_TIFF=OFF \
       -DBUILD_opencv_apps=OFF \
       -DBUILD_DOCS=OFF \
       -DBUILD_TESTS=OFF \
       -DWITH_JASPER=ON \
       -DWITH_PYTHON=OFF \
       -DWITH_PYTHON2=OFF \
       -DWITH_JAVA=OFF \
       -DWITH_FFMPEG=OFF \
       -DWITH_MSMF=OFF \
       -DWITH_VFW=OFF \
       -DWITH_OPENEXR=OFF \
       -DWITH_WEBP=OFF \
       -DWITH_TIFF=OFF \
       -DBUILD_opencv_java=OFF \
       -DBUILD_opencv_python=OFF \
       -DBUILD_opencv_python2=OFF \
       -DBUILD_opencv_python3=OFF \
       -DBUILD_opencv_python_bindings_generator=OFF \
       -DBUILD_TBB=ON \
       -DBUILD_LIST=imgproc,imgcodecs,objdetect,dnn,highgui \
       $THIS_DIR/$OPENCV_PACKAGE
fi

cd $BUILD_DIR && ninja && ninja install && cd ..

