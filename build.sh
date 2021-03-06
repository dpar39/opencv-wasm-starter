#!/bin/bash

# Build thirdparty libraries
cd thirdparty
bash ./build-opencv.sh "$1" "$2"
cd ..

BUILD_CONFIG=$1
if [ -z "$1" ] ; then
    BUILD_CONFIG=release
fi

BUILD_PLATFORM=$2
if [ -z "$2" ] ; then
    BUILD_PLATFORM=wasm
fi

BUILD_DIR=build_${BUILD_PLATFORM}_${BUILD_CONFIG}

# Clean-up
rm -f $BUILD_DIR/*.js*

if [ $BUILD_PLATFORM == "wasm" ]; then
    echo 'Running wasm build ... '
    source /emsdk/emsdk_env.sh
    cmake -G Ninja -B$BUILD_DIR \
        -DBUILD_PLATFORM=${BUILD_PLATFORM} \
        -DCMAKE_BUILD_TYPE=${BUILD_CONFIG} \
        -DCMAKE_MODULE_PATH=$EMSDK/upstream/emscripten/cmake \
        -DCMAKE_TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake .
fi

if [ $BUILD_PLATFORM == "x64" ]; then
    echo 'Running x64 build ... '
    cmake -G Ninja -B$BUILD_DIR \
        -DBUILD_PLATFORM=${BUILD_PLATFORM} \
        -DCMAKE_BUILD_TYPE=${BUILD_CONFIG} .
fi
cd $BUILD_DIR && ninja && cd ..

if [ $BUILD_PLATFORM == "wasm" ]; then
    cp $BUILD_DIR/*.wasm* example/
    cp $BUILD_DIR/*.js example/
fi

