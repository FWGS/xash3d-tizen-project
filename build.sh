#!/bin/bash

TIZEN=${HOME}/tizen-sdk/
TIZEN_DATA=${HOME}/tizen-sdk-data/
CMAKE=cmake
MAKE=make
ZIP=zip


MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd ${MY_DIR}

source keystore_config.sh

echo "-- Creating needed directories for package"
mkdir -p pkg/bin pkg/lib

echo "-- Building engine"
cd ${MY_DIR}/src/xash3d/
mkdir -p build && cd build
cmake ../ -DCMAKE_TOOLCHAIN_FILE=../cmake/TizenToolchain.cmake -DCMAKE_C_FLAGS="-Wl,--no-undefined" 
make -j5

echo "-- Building game"
cd ${MY_DIR}/src/hlsdk-xash3d
mkdir -p build && cd build
cmake ../ -DCMAKE_TOOLCHAIN_FILE=${MY_DIR}/tizen.toolchain.cmake -DCMAKE_C_FLAGS="-Wl,--no-undefined" 
make -j5

cd ${MY_DIR}

echo "-- Installing binaries"
cp ${MY_DIR}/src/xash3d/build/engine/xash ${MY_DIR}/pkg/bin
cp ${MY_DIR}/src/xash3d/build/mainui/libxashmenu.so ${MY_DIR}/pkg/lib/
cp ${MY_DIR}/src/hlsdk-xash3d/build/cl_dll/libclient.so ${MY_DIR}/src/hlsdk-xash3d/build/dlls/libserver.so ${MY_DIR}/pkg/lib/

echo "-- Signing"
${TIZEN}/tools/ide/bin/native-signing pkg ${TIZEN}/tools/certificate-generator/certificates/developer/tizen-developer-ca.cer ${TIZEN_DATA}/keystore/${KEYSTORE}/author.p12 ${PASSWORD} ${TIZEN}/tools/certificate-generator/certificates/distributor/tizen-distributor-signer.p12 tizenpkcs12passfordsigner ${TIZEN}/tools/certificate-generator/certificates/distributor/tizen-distributor-ca.cer ${TIZEN_DATA}/keystore/${KEYSTORE}/distributor.p12 ${PASSWORD} "" ""

echo "-- ZIP"
${ZIP} -0r in.celest.xash3d.hl.tpk pkg/*

echo "-- Done"

